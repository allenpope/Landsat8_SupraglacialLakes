%Inputs DEM-serived lake depths and sprectally derived lake depths for NW
%region, and outputs differences between the two

%Defines location where DEM-derived lake depths are stored
LakeDepths = 'cd ~/Dropbox/Landsat8Lakes/WV_DEM_compare/LakeDepths/';

%Defines location where spectrally derived lake depths (Method 1) are
%stored; there will need to be subfolders for each day
Spectral_depth_folder = ' ~/Google'' Drive''/Landsat8Lakes/Method1/LakeSpecificAlbedo/';

%Defines location where empirically derived lake depths (Method 2) are
%stored; there will need to be subfolders for each day
Ratio_depth_folder = ' ~/Google'' Drive''/Landsat8Lakes/Method2/';

%Defines location where depths from spectral mixture method are stored
%All stored in a subfolder "/4/", unless changes in the code
%there will need to be subfolders for each day
TwoBandDepths =' ~/Google'' Drive''/Landsat8Lakes/Method3/';

%Final location where outputted differences will be stored
Differences = 'cd ~/Dropbox/Landsat8Lakes/WV_DEM_compare/';

%Location where statistics from these comparisons will be stored
stats_folder = 'cd ~/Dropbox/Landsat8Lakes/WV_DEM_compare/stats/';

%DEMs, for each day
dems = {'cubic_12MAR12','cubic_13MAR26','cubic_13SEP29','cubic_13MAR22','cubic_13JUL19','cubic_13AUG10'};

%days
days = {'183','199','215','231'};
masks = {'LakeMask_183','LakeMask_199','LakeMask_215','LakeMask_231'};

%depths
depths = {'Band3_depth_Lake_Spec','Band4_depth_Lake_Spec','Band8_depth_Lake_Spec','Band13_depth','Band18_depth','Method3_23_depth','Band48_depth_Lake_Spec'};

diffs_concat = NaN(1,7);

for dem = 1:6
for day = 1:4
for dep = 1:7
    eval(LakeDepths);
    
    exp = strcat('dem_day = imread(''LakeDepth_',dems{dem},'_',masks{day},'.tif'');');
    eval(exp);
    dem_day = double(dem_day);
    
    if dep == 1
    exp = strcat('cd',Spectral_depth_folder,days(day));
    eval(exp{1});
    
    depth = imread('Band3_depth_Lake_Spec.tif');
    depth = double(depth);
    
    index = find(dem_day & depth);
    
    mask = zeros(size(dem_day));
    mask(index) = 1;
    
    area = size(index,1);
    dem_mean = mean(dem_day(index));
    dem_std = std(dem_day(index));
    depth_mean = mean(depth(index));
    depth_std = std(depth(index));
    
    diff1 = depth(index) - dem_day(index);
    
    DEM_comp_stats = struct('index',index);
    DEM_comp_stats.dem_values = dem_day(index);
    DEM_comp_stats.dem_mean = dem_mean;
    DEM_comp_stats.dem_std = dem_std;
    DEM_comp_stats.depth_values = depth(index);
    DEM_comp_stats.depth_mean = depth_mean;
    DEM_comp_stats.depth_std = depth_std;
    DEM_comp_stats.diff = diff1;
    end
    
    if dep == 2
    exp = strcat('cd',Spectral_depth_folder,days(day));
    eval(exp{1});
    dem_day = double(dem_day);
        
    depth = imread('Band4_depth_Lake_Spec.tif');
    depth = double(depth);   

    index = find(dem_day & depth);
    
    mask = zeros(size(dem_day));
    mask(index) = 1;
    
    area = size(index,1);
    dem_mean = mean(dem_day(index));
    dem_std = std(dem_day(index));
    depth_mean = mean(depth(index));
    depth_std = std(depth(index));

    diff2 = depth(index) - dem_day(index);
        
    DEM_comp_stats = struct('index',index);
    DEM_comp_stats.dem_values = dem_day(index);
    DEM_comp_stats.dem_mean = dem_mean;
    DEM_comp_stats.dem_std = dem_std;
    DEM_comp_stats.depth_values = depth(index);
    DEM_comp_stats.depth_mean = depth_mean;
    DEM_comp_stats.depth_std = depth_std;
    DEM_comp_stats.diff = diff2;
    end
    
    if dep == 3
    exp = strcat('cd',Spectral_depth_folder,days(day));
    eval(exp{1});
    dem_day = double(dem_day);
    
    rows = size(dem_day,1);
    cols = size(dem_day,2);
    temp = zeros(rows*2,cols*2);
    
    for row = 1:rows
        for col = 1:cols
            temp(2*row,2*col) = dem_day(row,col);
            temp(2*row-1,2*col) = dem_day(row,col);
            temp(2*row,2*col-1) = dem_day(row,col);
            temp(2*row-1,2*col-1) = dem_day(row,col);
        end
    end
    
    dem_day = temp;
        
    depth = imread('Band8_depth_Lake_Spec.tif');
    depth = double(depth);

    index = find(dem_day & depth);
    
    mask = zeros(size(dem_day));
    mask(index) = 1;
    
    area = size(index,1);
    dem_mean = mean(dem_day(index));
    dem_std = std(dem_day(index));
    depth_mean = mean(depth(index));
    depth_std = std(depth(index));
    
    diff3 = depth(index) - dem_day(index);
        
    DEM_comp_stats = struct('index',index);
    DEM_comp_stats.dem_values = dem_day(index);
    DEM_comp_stats.dem_mean = dem_mean;
    DEM_comp_stats.dem_std = dem_std;
    DEM_comp_stats.depth_values = depth(index);
    DEM_comp_stats.depth_mean = depth_mean;
    DEM_comp_stats.depth_std = depth_std;
    DEM_comp_stats.diff = diff3;
    end
    
    if dep == 4
    exp = strcat('cd',Ratio_depth_folder,days(day));
    eval(exp{1});
    dem_day = double(dem_day);
        
    depth = imread('Band13_depth.tiff');
    depth = double(depth);

    index = find(dem_day & depth);
    
    mask = zeros(size(dem_day));
    mask(index) = 1;
    
    area = size(index,1);
    dem_mean = mean(dem_day(index));
    dem_std = std(dem_day(index));
    depth_mean = mean(depth(index));
    depth_std = std(depth(index));
    
    diff4 = depth(index) - dem_day(index);
        
    DEM_comp_stats = struct('index',index);
    DEM_comp_stats.dem_values = dem_day(index);
    DEM_comp_stats.dem_mean = dem_mean;
    DEM_comp_stats.dem_std = dem_std;
    DEM_comp_stats.depth_values = depth(index);
    DEM_comp_stats.depth_mean = depth_mean;
    DEM_comp_stats.depth_std = depth_std;
    DEM_comp_stats.diff = diff4;
    end
    
    if dep == 5
    exp = strcat('cd',Ratio_depth_folder,days(day));
    eval(exp{1});
    dem_day = double(dem_day);
    
    depth = imread('Band18_depth.tiff');
    depth = double(depth);    
    
    index = find(dem_day & depth);
    
    mask = zeros(size(dem_day));
    mask(index) = 1;
    
    area = size(index,1);
    dem_mean = mean(dem_day(index));
    dem_std = std(dem_day(index));
    depth_mean = mean(depth(index));
    depth_std = std(depth(index));
    
    diff5 = depth(index) - dem_day(index);
        
    DEM_comp_stats = struct('index',index);
    DEM_comp_stats.dem_values = dem_day(index);
    DEM_comp_stats.dem_mean = dem_mean;
    DEM_comp_stats.dem_std = dem_std;
    DEM_comp_stats.depth_values = depth(index);
    DEM_comp_stats.depth_mean = depth_mean;
    DEM_comp_stats.depth_std = depth_std;
    DEM_comp_stats.diff = diff5;
    end
    
    if dep == 6
    exp = strcat('cd',TwoBandDepths,days(day),'/4');
    eval(exp{1});
    dem_day = double(dem_day);
        
    depth = imread('Method3_23_depth.tiff');
    depth = double(depth);
    
    index = find(dem_day & depth);
    
    mask = zeros(size(dem_day));
    mask(index) = 1;
    
    area = size(index,1);
    dem_mean = mean(dem_day(index));
    dem_std = std(dem_day(index));
    depth_mean = mean(depth(index));
    depth_std = std(depth(index));
    
    diff6 = depth(index) - dem_day(index);
        
    DEM_comp_stats = struct('index',index);
    DEM_comp_stats.dem_values = dem_day(index);
    DEM_comp_stats.dem_mean = dem_mean;
    DEM_comp_stats.dem_std = dem_std;
    DEM_comp_stats.depth_values = depth(index);
    DEM_comp_stats.depth_mean = depth_mean;
    DEM_comp_stats.depth_std = depth_std;
    DEM_comp_stats.diff = diff6;
    end
    
    if dep == 7
    exp = strcat('cd',Spectral_depth_folder,days(day));
    eval(exp{1});
    
    depth = imread('Band48_depth_Lake_Spec.tif');
    depth = double(depth);
    
    index = find(dem_day & depth);
    
    mask = zeros(size(dem_day));
    mask(index) = 1;
    
    area = size(index,1);
    dem_mean = mean(dem_day(index));
    dem_std = std(dem_day(index));
    depth_mean = mean(depth(index));
    depth_std = std(depth(index));
    
    diff7 = depth(index) - dem_day(index);

    DEM_comp_stats = struct('index',index);
    DEM_comp_stats.dem_values = dem_day(index);
    DEM_comp_stats.dem_mean = dem_mean;
    DEM_comp_stats.dem_std = dem_std;
    DEM_comp_stats.depth_values = depth(index);
    DEM_comp_stats.depth_mean = depth_mean;
    DEM_comp_stats.depth_std = depth_std;
    DEM_comp_stats.diff = diff7;        
    end

    eval(stats_folder);
    filename = strcat(dems(dem),days(day),'_',depths(dep),'.mat');
    filename = filename{1};
    save(filename,'DEM_comp_stats');
            
end

filename = strcat(dems(dem),days(day));
filename = filename{1};   

diff1 = diff1/1000; %mm to m
diff2 = diff2/1000;
diff3 = diff3/1000;
diff4 = diff4/1000;
diff5 = diff5/1000;
diff6 = diff6/1000;
diff7 = diff7/1000;

diffs = NaN(size(diff3,1),7);
diffs(1:size(diff1,1),1) = diff1(:,1);
diffs(1:size(diff2,1),2) = diff2(:,1);
diffs(1:size(diff3,1),3) = diff3(:,1);
diffs(1:size(diff4,1),4) = diff4(:,1);
diffs(1:size(diff5,1),5) = diff5(:,1);
diffs(1:size(diff6,1),6) = diff6(:,1);
diffs(1:size(diff7,1),7) = diff7(:,1);

diffs_concat = [diffs_concat;diffs];

end
end

eval(Differences);
save 'diffs_concat_NW' diffs_concat

%clear all
