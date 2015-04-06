%Code for using Landsat OLI imagery to delineate supraglacial lakes
%and estimate their depth. 

%This code tests all methods described in Pope et al. (2015) Sections 2.1, 2.2 and 3.2

%Scenes used are reported in Pope et al. (2015) Table S2 (doi: 10.6084/m9.figshare.1328470), 
%and also shown in Figure 1
%Results are reported in Pope et al. (2015) Section 4.2 & 4.4, Figures 4 & 5


%Step 1: Data organization must be as follows...
%Uncompress files downloaded from USGS
%In this case, all folders area then place in a single directory
%All orginal filenames, etc are retained

%Step 2: 
Jakobshavn_landsat_processing.m
%Reads in bands, calculates TOA reflectance, writes out geotiffs
%Uses MTL_parser.m to get information for TOA calculation
%Calculates blue/red ratio and sets threshold at 1.5, exports as LakeMask

%Step 3: 
%Lake Mask must then be manually cleaned to remove coastal areas and clouds
%This was done by comparison with QuickLook imagery in QGIS (qgis.org)

%Step 4: 
Jakobshavn_lake_sieve.m
%Removes small lakes (<5 pixels) and linear features

%Step 5: 
Jakobshavn_lake_depth_calc.m
%Need to manually script in Rinf values obtained through manual inspection
%Reads in sieved laked mask
%Goes through all methods described in the paper
    %Calls TwoBandDepth.m, used for solving the physical two-band method
%Writes out lake depths    

%Step 6: 
Jakobshavn_Band48_avg.m
%Takes Band 8 Depth and Band 4 Depth and averages to get a final lake depth

%Step 7: 
Jakobshavn_lake_vol_calc.m
%Reads in Band48 Depth average (i.e. the best)
%Scales based on pixels size and converts from mm

%Other:
Jakobshavn_lake_elev_stats.m
%Calculating depth - elevation statistics from depth & GIMP-DEM data

%Plotting Figure 3 using NW lake depth data directly
Figure3_code.m

%Plotting Figure 5 using Sermeq Kujalleq data directly
Figure5_code.m