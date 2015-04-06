%Inputs NW DEMs and Lake Masks and outputs DEM-derived lake depths

%"lakes" deeper than 65 meters removed as outliers
too_deep = 65;

%threshold to filter lakes based on their boundary properties
std_thresh = 1.5; %Lakes with a shoreline elevation std dev > 1.5 will be excluded

%defines location where filtered DEMs are stored
DEM_path = 'cd ~/Dropbox/Landsat8Lakes/WV_DEM_compare/Filtered_DEMs/;';

%defines location where Lake masks are stored
mask_path = 'cd ~/Dropbox/Landsat8Lakes/WV_DEM_compare/LakeMasks/;';

%Defines location where lake depths will be stored
LakeDepths = 'cd ~/Dropbox/Landsat8Lakes/WV_DEM_compare/LakeDepths;';

%defines location of one NW subset image for georeferencing information
cd ~/Dropbox/Landsat8Lakes/Method1/LakeSpecificAlbedo/183/ 
[image, image_info] = geotiffread('Band3_subset.tif'); %used for georeference info
tiffinfo = geotiffinfo('Band3_subset.tif'); %used for georeference info
clear image

dems = {'cubic_12MAR12'; ...
    'cubic_13MAR26'; ...
    'cubic_13SEP29'; ...
    'cubic_13MAR22';...
    'cubic_13JUL19';...
    'cubic_13AUG10'}; %Use all filtered DEMs, all in m

masks = {'LakeMask_183','LakeMask_199','LakeMask_215','LakeMask_231'};
    
for file = 1:size(dems,1)
   for day = 1:4 
       %move to folder where DEMs are
       eval(DEM_path);
       
       %import % format DEM 
       exp = strcat('[dem,dem_info] = geotiffread(''',dems{file},'.tif'');');
       eval(exp);
       
       dem = double(dem);
       dem(find(dem<0)) = 0; %removes negative DEM values
       
       
       %move to folder where lake masks are
       eval(mask_path);
    
       %import, format, and sieve lake mask
       exp = strcat('LakeMask = imread(''',masks{day},'.tif'');');
       eval(exp);
       LakeMask = double(LakeMask);
       
       CC = bwconncomp(LakeMask,4);
       for lake = 1:CC.NumObjects
           if size(CC.PixelIdxList{lake},1) < 5
               LakeMask(CC.PixelIdxList{lake}) = 0;
           else %all same row or all same column
               [r,c] = ind2sub(size(LakeMask),CC.PixelIdxList{lake});
               r = unique(r);
               c = unique(c);
               if size(r,1) == 1 || size(c,1) == 1;
                   LakeMask(CC.PixelIdxList{lake}) = 0;
               end
           end
       end
       
       clear CC r c
       
       LakeMask_thick = bwmorph(LakeMask,'thicken',1);
       LakeMask = bwmorph(LakeMask_thick,'thin',1);

       LakeMask_thick = double(LakeMask_thick);
       LakeMask = double(LakeMask);

       
       %because there is a small offset (from somewhere) in the masks...
       %this value is in pixels and should be 10 for day 215 and 20 for day 231, 0 for 183 & 199
       %if day == 1 || day == 2
           offset = 0; 
       %elseif day == 3;
       %    offset = 10;
       %elseif day == 4;
       %    offset = 20;
       %end
           
       LakeMask_temp = zeros(size(LakeMask));
       for col = (offset+1):2301;
           LakeMask_temp(:,col-offset) = LakeMask(:,col);
       end
       LakeMask = LakeMask_temp;
       clear LakeMask_temp
       
       LakeMask_thick_temp = zeros(size(LakeMask));
       for col = (offset+1):2301;
           LakeMask_thick_temp(:,col-offset) = LakeMask_thick(:,col);
       end
       LakeMask_thick = LakeMask_thick_temp;
       clear LakeMask_thick_temp col
       
       
       %calculating the 0-elevation
       CC = bwconncomp(LakeMask_thick,8);
       num_lakes = CC.NumObjects;
       zero_elevs = zeros(num_lakes,1);
       bound_stds = zeros(num_lakes,1);
       
       lake_boundaries = bwboundaries(LakeMask_thick,8,'noholes');
       for lake=1:num_lakes
           bound = lake_boundaries{lake};
           bound = sub2ind(size(LakeMask),bound(:,1),bound(:,2));
           zero_temp = dem(bound);
           zero_temp(find(zero_temp == 0)) = [];
           zero_elevs(lake) = mean(zero_temp);
           bound_stds(lake) = std(zero_temp);
       end

       exp = strcat('bound_stds_',dems{file},'_',masks{day},' = bound_stds;');
       eval(exp);
       
       %calculating DEM-derived lake depths
       props = regionprops(CC,dem,{'Area', 'PixelValues', 'PixelIdxList'}); %for each lake, extracts important info from dem; 2nd use of props
       
       bad_lakes = []; %to build list of now nonexistant lakes after negative filtering...
       lake_depth = zeros(size(dem)); %to fill in lake depths
       
       for lake = 1:num_lakes
           props(lake).PixelValues = zero_elevs(lake) - props(lake).PixelValues; %remove border elevation to calc lake depth
           temp_index = find(props(lake).PixelValues <= 0); %find negative values
           props(lake).Area = props(lake).Area - size(temp_index,1); %remove # of neg values from area
           props(lake).PixelValues(temp_index) = []; %remove negative values
           props(lake).PixelIdxList(temp_index) = []; %remove indices of negative pixels
           
           temp_index = find(props(lake).PixelValues > too_deep); %find too deep values
           props(lake).Area = props(lake).Area - size(temp_index,1); %remove # of too deep values from area
           props(lake).PixelValues(temp_index) = []; %remove too deep values
           props(lake).PixelIdxList(temp_index) = []; %remove indices of too deep pixels
           
           if bound_stds(lake) > std_thresh %removing lakes based on consistency of lake shore depths
               bad_lakes = [bad_lakes; lake]; %adds to list of zero lakes with bad lakes
           end
           
           if 1 == isnan(sum(props(lake).PixelValues))
               bad_lakes = [bad_lakes; lake]; %adds to list of zero lakes with nan lakes (i.e. no overlap)
           end
       end
       
       props(bad_lakes) = []; %removes the now zero-area lakes
       num_lakes = size(props,1); %corrects the number of lakes


       %filtering lake depths based on IQR outlier definition       
       for lake = 1:num_lakes
           %average = mean(props(lake).PixelValues);
           %stdev = std(props(lake).PixelValues);
           %index = find(props(lake).PixelValues > (average + 3* stdev)); %outliers defined as outside 3 sigma
           q1 = quantile(props(lake).PixelValues,0.25);
           q3 = quantile(props(lake).PixelValues,0.75);
           iqr = q3-q1;
           index = find(props(lake).PixelValues > (q3 + 1.5*iqr) | props(lake).PixelValues < (q1 - 1.5*iqr)); %outliers defined as outside 1.5 iqr
           
           props(lake).PixelValues(index) = [];
           props(lake).PixelIdxList(index) = [];
           
           lake_depth(props(lake).PixelIdxList) = props(lake).PixelValues; %writes calculated lake depths to a new file
       end
       
       
       %writing out lake depth file
       lake_depth = lake_depth*1000; %takes DEM in meters and turns lake depth to mm
       lake_depth(1,1) = 2^16-1;
       lake_depth = uint16(lake_depth);
       lake_depth(1,1) = 0;
       
       %move to folder where lake depths should go
       eval(LakeDepths);
       
       exp = strcat('geotiffwrite(''LakeDepth_',dems{file},'_',masks{day},'.tif'',lake_depth, image_info, ''GeoKeyDirectoryTag'',tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
       eval(exp);
       
       clear props bad_lakes lake_depth temp_index q1 q3 iqr index
       clear dem exp LakeMask LakeMask_thick offset CC num_lakes bound zero_elevs bound_stds zero_temp lake
       clear lake_boundaries dem_info 
   end
end

clear dems masks std_thresh day file tiffinfo image_info