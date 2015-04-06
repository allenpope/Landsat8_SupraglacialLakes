%Takes WorldView DEMs and Landsat-derived lake depths and compares them
%outputs a list of their differences which can then be used for statistics

%Define directory where DEMs are stored
directory = ' ~/Google'' Drive''/LandsatLakes/cubic_tr16x/';
folder = 'cubic_tr16x'; %The subfolder also indicated the interpolation of the DEM

%Define where Landsat folders are stored
Landsat_dir = 'cd ~/Documents/GreenlandLakes/Jakobshavn/';

%"lakes" deeper than 65 meters removed as outliers
too_deep = 65;
%Lakes with shore elevation standard deviations greater than 1.5m will be excluded
std_threshold = 1.5; 

%All pairs need to be hard-coded based on those which have overlap areas
pairs = {'20130705_1510_0060122014195';... %pairs of landsat & DEMs
    '20130705_1510_0060122014211';...
    '20130705_1510_0070122014218';...
    '20130722_0038_0090112014184';...
    '20130722_0038_0090112014200';...
    '20130722_0038_0090112014216';...
    '20130722_1552_0090112014184';...
    '20130722_1552_0090112014200';...
    '20130722_1552_0090112014216';...
    '20130804_1611_0070122014218';...
    '20130804_1611_0080122014193';...
    '20130804_1611_0090112014184';...
    '20130804_1611_0090112014200';...
    '20130804_1611_0090112014216';...
    '20130819_1518_0070122014218';...
    '20130819_1518_0080122014193';...
    '20130819_1518_0090112014184';...
    '20130819_1518_0090112014200';...
    '20130819_1518_0090112014216';...
    '20130929_1510_0090122014184';...
    '20130929_1510_0090122014216'};

    diff1 = NaN(1,1); %Band 3 single band depth
    diff2 = NaN(1,1); %Band 4 single band depth
    diff3 = NaN(1,1); %Band 8 single band depth
    diff4 = NaN(1,1); %Bands 1/3 ratio depth
    diff5 = NaN(1,1); %Bands 1/8 ratio depth
    diff6 = NaN(1,1); %Bands 2 & 3 physically-based depth
    diff7 = NaN(1,1); %Band 4 & Band 8 single band average depth
    
    for pair = 1:size(pairs,1)
        %move to folder with the DEMs in it
        exp = strcat('cd ',directory,';');
        eval(exp);
    
        %read in & format DEM, geotiff
        exp = strcat('[dem,dem_info] = geotiffread(''',folder,'_',pairs{pair},'.tif'');');
        eval(exp);
        
        exp = strcat('tiffinfo = geotiffinfo(''',folder,'_',pairs{pair},'.tif'');');
        eval(exp);
        
        dem = double(dem);
    
        %parsing input info for Landsat info
        ls = char(pairs{pair});
        ls = ls(15:27);
        
        %navigating to correct folder and importing / formatting LakeMask
        eval(Landsat_dir);
        
        exp = strcat('exist LC8',ls,'LGN00 ; ');
        eval(exp);
        
        a = ans;
        clear ans;
        
        if a > 0
            exp = strcat(Landsat_dir,'LC8',ls,'LGN00/');
            eval(exp)
            
            exp = strcat('LakeMask = imread(''LC8',ls,'LGN00_lake_mask_sieve.tif'');');
            eval(exp);
            
            ls_ext = strcat(ls,'LGN00');
        else
            exp = strcat(Landsat_dir,'LC8',ls,'LGN01/');
            eval(exp)
            
            exp = strcat('LakeMask = imread(''LC8',ls,'LGN01_lake_mask_sieve.tif'');');
            eval(exp);
            
            ls_ext = strcat(ls,'LGN01');
        end
        
        LakeMask = double(LakeMask);
        
        %Creating self-consistent masks
        LakeMask_thick = bwmorph(LakeMask,'thicken',1);
        LakeMask = bwmorph(LakeMask_thick,'thin',1);

        LakeMask_thick = double(LakeMask_thick);
        LakeMask = double(LakeMask);

        %remove areas not covered by the DEM & the lakemask
        index = find(dem & LakeMask);
        LakeMask = zeros(size(LakeMask));
        LakeMask(index) = 1;

        index = find(dem & LakeMask_thick);
        LakeMask_thick = zeros(size(LakeMask_thick));
        LakeMask_thick(index) = 1;
        
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

        exp = strcat('bound_stds_',pairs{pair},' = bound_stds;');
        eval(exp);

        %calculating lake depths
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
            
            if bound_stds(lake) > std_threshold
                bad_lakes = [bad_lakes; lake]; %adds to list of zero lakes with bad lakes
            end
            
            %if 1 == isnan(sum(props(lake).PixelValues))
            %    bad_lakes = [bad_lakes; lake]; %adds to list of zero lakes with nan lakes (i.e. no overlap)
            %end
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
        
        exp = strcat('geotiffwrite(''LC8',ls_ext,folder,'_depth1.tif'',lake_depth, dem_info, ''GeoKeyDirectoryTag'',tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
        eval(exp)
        
        %not to compare with Spectral Depths...
        depths = {'Band3_depth_Lake_Spec','Band4_depth_Lake_Spec','Band8_depth_Lake_Spec','Band13_depth','Band18_depth','Method3_23_depth'};
        lake_depth = double(lake_depth);
        
        diffs_concat = NaN(1,7);
        for dep = 1:7
            if dep == 1
                exp = strcat('depth = imread(''LC8',ls_ext,'_B3_depth1.tif'');');
                eval(exp);
                depth = double(depth);
                
                index = find(lake_depth & depth);
    
                diff = depth(index) - lake_depth(index);
                diff1 = [diff1;diff];
            end
    
            if dep == 2
                exp = strcat('depth = imread(''LC8',ls_ext,'_B4_depth1.tif'');');
                eval(exp);
                depth = double(depth);
                
                index = find(lake_depth & depth);
    
                diff = depth(index) - lake_depth(index);
                diff2 = [diff2;diff];
            end

            if dep == 3
                exp = strcat('depth = imread(''LC8',ls_ext,'_B8_depth1.tif'');');
                eval(exp);
                depth = double(depth);
                
                index = find(lake_depth & depth);
    
                diff = depth(index) - lake_depth(index);
                diff3 = [diff3;diff];
            end

            if dep == 4
                exp = strcat('depth = imread(''LC8',ls_ext,'_B13_depth1.tif'');');
                eval(exp);
                depth = double(depth);
                
                index = find(lake_depth & depth);
    
                diff = depth(index) - lake_depth(index);
                diff4 = [diff4;diff];
            end

            if dep == 5
                exp = strcat('depth = imread(''LC8',ls_ext,'_B18_depth1.tif'');');
                eval(exp);
                depth = double(depth);
                
                index = find(lake_depth & depth);
    
                diff = depth(index) - lake_depth(index);
                diff5 = [diff5;diff];
            end

            if dep == 6
                exp = strcat('depth = imread(''LC8',ls_ext,'_B23_depth1.tif'');');
                eval(exp);
                depth = double(depth);
                
                index = find(lake_depth & depth);
    
                diff = depth(index) - lake_depth(index);
                diff6 = [diff6;diff];
            end
            
            if dep == 7
                exp = strcat('depth = imread(''LC8',ls_ext,'_B48_depth1.tif'');');
                eval(exp);
                depth = double(depth);
                
                index = find(lake_depth & depth);
    
                diff = depth(index) - lake_depth(index);
                diff7 = [diff7;diff];
            end
        end %end of 7 kinds of depth
    end %end of each pair

    length = max([size(diff1,1),size(diff2,1),size(diff3,1),size(diff4,1),size(diff5,1),size(diff6,1),size(diff7,1)]);
    diffs = NaN(length,7);
    
    diffs(1:size(diff1,1),1) = diff1(:,1);
    diffs(1:size(diff2,1),2) = diff2(:,1);
    diffs(1:size(diff3,1),3) = diff3(:,1);
    diffs(1:size(diff4,1),4) = diff4(:,1);
    diffs(1:size(diff5,1),5) = diff5(:,1);
    diffs(1:size(diff6,1),6) = diff6(:,1);
    diffs(1:size(diff7,1),7) = diff7(:,1);
    
    diffs = diffs/1000; %take from mm to m
    diffs(1,:) = []; %removes first row of nans
        
    exp = strcat('save ''diffs_concat_',folder,''' diffs ;');
    eval(exp)


clear exp dem dem_info tiffinfo ls a CC num_lakes LakeMask LakeMask_thick
clear zero_elevs bound_stds lake_boundaries lake zero_temp temp_index
clear bad_lakes lake_depth props iqr q1 q3 std_thresh diffs diffs_concat
clear bound  dep depth depths diff1 diff2 diff3 diff4 diff5 diff6 diff7
clear folder index ls_ext pair pairs std_threshold diff length
%clear bound_stds*
