%Reads in bands, calculates TOA reflectance, writes out geotiffs
%Uses MTL_parser.m to get information for TOA calculation
%Calculates blue/red ratio and sets threshold at 1.5, exports as LakeMask

%Make sure MTL_parser.m is in an active folder

%Define directory where Landsat scene folders are stored
directory = ' /Volumes/ELEMENTS/SermeqKujalleq2015/HighRez/';

%Blue/Red Ratio Threshold
threshold = 1.5;

%Create list of all Landsat scenes to be used 
Scenes = {'LC80060122015166LGN00'; ... Notes
'LC80060122015182LGN00'; ...
'LC80060122015198LGN00'; ...
'LC80060122015214LGN00'; ...
'LC80060132015166LGN00'; ...
'LC80060132015182LGN00'; ...
'LC80060132015198LGN00'; ...
'LC80060132015214LGN00'; ...
'LC80060132015230LGN00'; ...
'LC80060142015166LGN00'; ...
'LC80060142015182LGN00'; ...
'LC80060142015198LGN00'; ...
'LC80060142015214LGN00'; ...
'LC80060152015166LGN00'; ...
'LC80060152015182LGN00'; ...
'LC80060152015198LGN00'; ...
'LC80060152015214LGN00'; ...
'LC80070122015189LGN00'; ...
'LC80070122015237LGN00'; ...
'LC80070132015189LGN00'; ...
'LC80070132015205LGN01'; ...
'LC80070132015237LGN00'; ...
'LC80070132015253LGN00'; ...
'LC80070142015189LGN00'; ...
'LC80070142015205LGN01'; ...
'LC80070142015237LGN00'; ...
'LC80070142015253LGN00'; ...
'LC80080112015180LGN00'; ...
'LC80080112015196LGN00'; ...
'LC80080112015212LGN00'; ...
'LC80080112015228LGN00'; ...
'LC80080122015164LGN00'; ...
'LC80080122015180LGN00'; ...
'LC80080122015196LGN00'; ...
'LC80080122015212LGN00'; ...
'LC80090112015155LGN00'; ...
'LC80090112015187LGN00'; ...
'LC80090112015235LGN00'; ...
'LC80090112015251LGN00'; ...
'LC80090122015155LGN00'; ...
'LC80090122015171LGN00'; ...
'LC80090122015187LGN00'; ...
'LC80090122015235LGN00'; ...
'LC80090122015251LGN00'; ...
'LC80100112015162LGN00'; ...
'LC80100112015194LGN00'; ...
'LC80100112015210LGN00'; ...
'LC80100112015226LGN00'};

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