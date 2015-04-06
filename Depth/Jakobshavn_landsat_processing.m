%Reads in bands, calculates TOA reflectance, writes out geotiffs
%Uses MTL_parser.m to get information for TOA calculation
%Calculates blue/red ratio and sets threshold at 1.5, exports as LakeMask

%Make sure MTL_parser.m is in an active folder

%Define directory where Landsat scene folders are stored
directory = ' ~/Google'' Drive''/LandsatLakes/';

%Blue/Red Ratio Threshold
threshold = 1.5;

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
    
    %read metadata
    expression = strcat('mtl = MTL_parser(''',Scenes{scene},'_MTL.txt'');');
    eval(expression);
    
    %read in B1
    expression = strcat('[B1, B1_info] = geotiffread(''',Scenes{scene},'_B1.TIF'');');
    eval(expression);
    expression = strcat('B1_tiffinfo = geotiffinfo(''',Scenes{scene},'_B1.TIF'');');
    eval(expression);
    
    
        
        %Calculate reflectances
        B1 = double(B1);
        B1 = (B1*0.00002-0.100000) / sin(mtl.IMAGE_ATTRIBUTES.SUN_ELEVATION * pi / 180); %reflectance and solar elevation corrections
        B1 = B1*10000;
        B1(find(B1==-1000)) = 0;
        B1(1,1) = 2^16-1;
        B1 = uint16(B1);
        B1(1,1) = 0;

        %write B1_ref
        expression = strcat('geotiffwrite(''',Scenes{scene},'_B1_ref.TIF'', B1, B1_info, ''GeoKeyDirectoryTag'',B1_tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
        eval(expression)
        
        %clean up
        clear B1 B1_info B1_tiffinfo
        
    %read in B2
    expression = strcat('[B2, B2_info] = geotiffread(''',Scenes{scene},'_B2.TIF'');');
    eval(expression);
    expression = strcat('B2_tiffinfo = geotiffinfo(''',Scenes{scene},'_B2.TIF'');');
    eval(expression);
        
        %Calculate reflectances
        B2 = double(B2);
        B2 = (B2*0.00002-0.100000) / sin(mtl.IMAGE_ATTRIBUTES.SUN_ELEVATION * pi / 180);
        B2 = B2*10000;
        B2(find(B2==-1000)) = 0;
        B2(1,1) = 2^16-1;
        B2 = uint16(B2);
        B2(1,1) = 0;
 
        %write B2_ref
        expression = strcat('geotiffwrite(''',Scenes{scene},'_B2_ref.TIF'', B2, B2_info, ''GeoKeyDirectoryTag'',B2_tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
        eval(expression)
        
        %clean up
        
        
    %read in B3
    expression = strcat('[B3, B3_info] = geotiffread(''',Scenes{scene},'_B3.TIF'');');
    eval(expression);
    expression = strcat('B3_tiffinfo = geotiffinfo(''',Scenes{scene},'_B3.TIF'');');
    eval(expression);
        
        %Calculate reflectances
        B3 = double(B3);
        B3 = (B3*0.00002-0.100000) / sin(mtl.IMAGE_ATTRIBUTES.SUN_ELEVATION * pi / 180);
        B3 = B3*10000;
        B3(find(B3==-1000)) = 0;
        B3(1,1) = 2^16-1;
        B3 = uint16(B3);
        B3(1,1) = 0;
 
        %write B3_ref
        expression = strcat('geotiffwrite(''',Scenes{scene},'_B3_ref.TIF'', B3, B3_info, ''GeoKeyDirectoryTag'',B3_tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
        eval(expression)
        
        %clean up
        clear B3 B3_info B3_tiffinfo

    %read in B4
    expression = strcat('[B4, B4_info] = geotiffread(''',Scenes{scene},'_B4.TIF'');');
    eval(expression);
    expression = strcat('B4_tiffinfo = geotiffinfo(''',Scenes{scene},'_B4.TIF'');');
    eval(expression);
        
        %Calculate reflectances
        B4 = double(B4);
        B4 = (B4*0.00002-0.100000) / sin(mtl.IMAGE_ATTRIBUTES.SUN_ELEVATION * pi / 180);
        B4 = B4*10000;
        B4(find(B4==-1000)) = 0;
        B4(1,1) = 2^16-1;
        B4 = uint16(B4);
        B4(1,1) = 0;
 
        %write B4_ref
        expression = strcat('geotiffwrite(''',Scenes{scene},'_B4_ref.TIF'', B4, B4_info, ''GeoKeyDirectoryTag'',B4_tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
        eval(expression)
        
        %ratio calc
        B2 = double(B2);
        B4 = double(B4);
        ratio = B2./B4;
        lake_mask = zeros(size(B2));
        lake_mask = uint16(lake_mask);
        index = find(ratio > threshold);
        lake_mask(index) = 1;
            %ratio = ratio*10000;
            %a = ratio(1,1);
            %b = ratio(1,2);
            %ratio(1,1) = 0;
            %ratio(1,2) = 2^16-1;
            %ratio = uint16(ratio);
            %ratio(1,1) = a;
            %ratio(1,2) = b;
        
        %write lake_mask
        expression = strcat('geotiffwrite(''',Scenes{scene},'_lake_mask.TIF'', lake_mask, B2_info, ''GeoKeyDirectoryTag'',B2_tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
        eval(expression)
        
        %clean up
        clear B4 B4_info B4_tiffinfo
        clear B2 B2_info B2_tiffinfo
        clear ratio lake_mask index %a b 

    %read in B8
    expression = strcat('[B8, B8_info] = geotiffread(''',Scenes{scene},'_B8.TIF'');');
    eval(expression);
    expression = strcat('B8_tiffinfo = geotiffinfo(''',Scenes{scene},'_B8.TIF'');');
    eval(expression);
        
        %Calculate reflectances
        B8 = double(B8);
        B8 = (B8*0.00002-0.100000) / sin(mtl.IMAGE_ATTRIBUTES.SUN_ELEVATION * pi / 180);
        B8 = B8*10000;
        B8(find(B8==-1000)) = 0;
        B8(1,1) = 2^16-1;
        B8 = uint16(B8);
        B8(1,1) = 0;
 
        %write B8_ref
        expression = strcat('geotiffwrite(''',Scenes{scene},'_B8_ref.TIF'', B8, B8_info, ''GeoKeyDirectoryTag'',B8_tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
        eval(expression)
        
        %clean up
        clear B8 B8_info B8_tiffinfo
end

expression = strcat('cd ''',home,'''');
eval(expression)

clear home Scenes scene expression mtl