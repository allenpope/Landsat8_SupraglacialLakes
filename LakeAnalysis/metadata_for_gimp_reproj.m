%Takes scenes listed below and creates gdal code to reproject GIMP DEM to
%their footprints

%Define directory where Landsat scene folders are stored
directory = ' ~/Google'' Drive''/LandsatLakes/';

%Ensure that MTL_parser.m is in an active folder

%Create list of all Landsat scenes to be used 
    %(I included notes about the%masks used to clean these manually later)
    %These were edited manually for Northwest Scenes
Scenes = {%'LC80060122014163LGN00'; ... No lakes
'LC80060122014195LGN00'; ...
'LC80060122014211LGN00'; ... Think clouds over a handful of high lakes
'LC80060132014163LGN00'; ... Cleaned coast
'LC80060132014195LGN00'; ... Cleaned coast
'LC80060132014211LGN00'; ... Cleaned coast
'LC80060132014243LGN00'; ... Cleaned coast
'LC80060142014163LGN00'; ... Cleaned coast - more complicated
'LC80060142014195LGN00'; ... Used same mask as day 163
'LC80060142014211LGN00'; ... Used same mask as day 163
'LC80060142014243LGN00'; ... Used same mask as day 163
'LC80060152014163LGN00'; ... Cleaned coast - more complicated
'LC80060152014195LGN00'; ... Used same mask as day 163
'LC80060152014211LGN00'; ... Used same mask as day 163
'LC80060152014243LGN00'; ... Used same mask as day 163
'LC80070122014218LGN00'; ... One mask for this image and next
'LC80070132014218LGN00'; ... One mask for this image and previous
'LC80070142014170LGN00'; ... Complicated coast, and some clouds
'LC80070142014218LGN00'; ... Used same mask as 170
'LC80080112014161LGN00'; ... One mask for this image and next
'LC80080112014193LGN01'; ... One mask for this image and previous
'LC80080122014161LGN00'; ... One mask for this image and next -- make clear that am just ridding of close to edge, meaning losing some lakes...
'LC80080122014193LGN01'; ... One mask for this image and previous -- also getting rid of crevassed areas where I see them
%'LC80090112014152LGN00'; ... Moats unfreezing only
'LC80090112014184LGN00'; ... Removed coastal area, tried to remove crevassed zone
'LC80090112014200LGN00'; ... Same mask as day 184
'LC80090112014216LGN00'; ... Same mask as day 184
%'LC80090122014152LGN00'; ... Lakes in crevasses only
'LC80090122014184LGN00'; ... Combine with 009012 mask
'LC80090122014216LGN00'; ... Same mask as above
'LC80100112014159LGN00'; ... Added to previous mask
'LC80100112014207LGN00'; ... Used as above
'LC80100112014223LGN00'; ... Used as above
'LC80100112014239LGN00'}; %Used as above


home = pwd ;
addpath(pwd);

UL_X = zeros(size(Scenes)); %xmin
UL_Y = zeros(size(Scenes)); %ymax
LR_X = zeros(size(Scenes)); %xmax
LR_Y = zeros(size(Scenes)); %ymin
UTM = zeros(size(Scenes)); %epsg

for scene = 1:size(Scenes,1);
    %change to appropriate directory
    expression = strcat('cd ',directory,Scenes{scene},'/');
    eval(expression);
    
    %read metadata
    expression = strcat('mtl = MTL_parser(''',Scenes{scene},'_MTL.txt'');');
    eval(expression);
    
    UL_X(scene) = mtl.PRODUCT_METADATA.CORNER_UL_PROJECTION_X_PRODUCT;
    UL_Y(scene) = mtl.PRODUCT_METADATA.CORNER_UL_PROJECTION_Y_PRODUCT;
    LR_X(scene) = mtl.PRODUCT_METADATA.CORNER_LR_PROJECTION_X_PRODUCT;
    LR_Y(scene) = mtl.PRODUCT_METADATA.CORNER_LR_PROJECTION_Y_PRODUCT;
    
    UTM(scene) = mtl.PROJECTION_PARAMETERS.UTM_ZONE + 32600; %the addition gives it the correct EPSG
    
end

%edit corners given 30m pixels
UL_X = UL_X-15;
UL_Y = UL_Y+15;
LR_X = LR_X+15;
LR_Y = LR_Y-15;

%writing expressions
for_gdal = cell(28,1);
for scene = 1:size(Scenes,1);
    for_gdal{scene} = strcat('gdalwarp -s_srs EPSG:3995 -t_srs EPSG:',num2str(UTM(scene)),' -te ',num2str(UL_X(scene)),' ',num2str(LR_Y(scene)),' ',num2str(LR_X(scene)),' ',num2str(UL_Y(scene)),' -tr 30 30 -r near -of GTiff /Users/apope/Documents/GreenlandLakes/DEMs/gimpdem_90m_PolarStereo.tif /Users/apope/Documents/GreenlandLakes/Jakobshavn/',Scenes{scene},'/',Scenes{scene},'_gimp.tif');
end

%output
dlmwrite('GIMP_reproject_gdal.txt',for_gdal)
%to correct an error, I had to add this line at beginning: export PROJSO=/Library/Frameworks/PROJ.framework/PROJ
%then remove commas in textedit and add spaces between appropriate numbers
%e.g. gdalwarp -s_srs EPSG:3995 -t_srs EPSG:32623 -te 314085 7444185 572115 7704015 -tr 30 30 -r near -of GTiff /Users/apope/Documents/GreenlandLakes/DEMs/gimpdem_90m_PolarStereo.tif /Users/apope/Documents/GreenlandLakes/Jakobshavn/LC80060122014195LGN00/LC80060122014195LGN00_gimp.tif