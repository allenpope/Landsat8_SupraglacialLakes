%Takes Band 8 Depth and Band 4 Depth and averages to get a final lake depth

%Define directory where Landsat scene folders are stored
directory = ' ~/Google'' Drive''/LandsatLakes/';

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

for scene = 1:size(Scenes,1);
    %change to appropriate directory
    expression = strcat('cd ',directory,Scenes{scene},'/');
    eval(expression);
    
    %read in Band8
    expression = strcat('[B8, B8_info] = geotiffread(''',Scenes{scene},'_B8_depth1.tif'');'); %depth1 = OLIg, depth = Sneedg
    eval(expression);
    expression = strcat('B8_tiffinfo = geotiffinfo(''',Scenes{scene},'_B8_depth1.tif'');');
    eval(expression);

    %read in Band4
    expression = strcat('[B4, B4_info] = geotiffread(''',Scenes{scene},'_B4_depth1.tif'');');
    eval(expression);
    expression = strcat('B4_tiffinfo = geotiffinfo(''',Scenes{scene},'_B4_depth1.tif'');');
    eval(expression);
    
    %take average
    index = find(B8 & B4);
    B48 = zeros(size(B4));
    B48(index) = (B4(index) + B8(index))/2;
    
    %write out average
    expression = strcat('geotiffwrite(''',Scenes{scene},'_B48_depth1.tif'', B48, B4_info, ''GeoKeyDirectoryTag'',B4_tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
    eval(expression)
end


expression = strcat('cd ''',home,'''');
eval(expression)

clear