%Inputs unfiltered WV DEMs and applied a median filter to remove outliers,
%outputting filtered DEMs

%Currently set to filter using a 7x7 kernel
%define below as rounding down from half of the size of the full kernel
half_kernel_size = 3;

%threshold to remove anything more than 30m from the median of the kernel
threshold  = 30;

%defines location where unfiltered DEMs are stored
DEM_path = 'cd ~/Dropbox/Landsat8Lakes/WV_DEM_compare/Unfiltered_DEMs/;';

%Defines location where filtered DEMS will be stored
output = 'cd ~/Dropbox/Landsat8Lakes/WV_DEM_compare/Filtered_DEMs/;';

%prepping for file output
%defines location of one NW subset image for georeferencing information
cd ~/Dropbox/Landsat8Lakes/Method1/LakeSpecificAlbedo/183/
[image, image_info] = geotiffread('Band3_subset.tif'); %used for georeference info
tiffinfo = geotiffinfo('Band3_subset.tif'); %used for georeference info
clear image

dems = {'cubic_12MAR12.tif';...
    'cubic_13MAR26.tif';...
    'cubic_13SEP29.tif'; ...
    'cubic_13MAR22.tif';...
    'cubic_13JUL19.tif';...
    'cubic_13AUG10.tif'};

for file = 1:size(dems,1);
    %folder where unfiltered DEMs are
    eval(DEM_path);
    
    exp = strcat('dem = imread(''',dems{file},''');');
    eval(exp);
    
    rows = size(dem,1);
    cols = size(dem,2);

    %start by removing negative values, just in case
    dem(find(dem < 0)) = 0;
    
    %filtering of too-small lakes already done to the LakeMask in sieving
    
    %The filtering process..
    index = find(dem);

    %Remove things close to the edge of the subset
    [I,J] = ind2sub(size(dem),index);
    
    to_del1 = find(I<4);
    to_del2 = find(J<4);
    to_del3 = find(I>(rows-4));
    to_del4 = find(J>(cols-4));
    to_del = [to_del1;to_del2;to_del3;to_del4];
    I(to_del) = [];
    J(to_del) = [];
    index(to_del) = [];

    pixels = size(index,1);

    dem_temp = zeros(size(dem));
    
    for ind = 1:pixels; %faster than all pixels
        r = I(ind);
        c = J(ind);
    
        left = c-half_kernel_size;
        right = c+half_kernel_size;
        bottom = r+half_kernel_size;
        top = r-half_kernel_size;
        kernel = dem(top:bottom,left:right);

        k_index = find(kernel); %to include only data regions
        
        k_med = median(kernel(k_index));
        
        value = abs(dem(r,c)-k_med);
        
        if value < threshold %everything is brought in as meters
            dem_temp(r,c) = dem(r,c);
        end
    end
    

    
    %folder where filtered DEMs should be put
    eval(output);
    
    %write out file
    dem = dem_temp;
    dem = single(dem); %dem stays in meters
    %dem(1,1) = 2^16-1;
    %dem = uint16(dem);
    %dem(1,1) = 0;
    
    exp = strcat('geotiffwrite(''',dems{file},''', dem, image_info, ''GeoKeyDirectoryTag'',tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
    eval(exp);
    
    %clean up
    clear exp dem dem_temp to_del1 to_del2 to_del3 to_del4 to_del value ind;
    clear I J pixels index left right bottom top kernel k_index k_med r c;
    clear rows cols; 
end

clear dems file image_info tiffinfo