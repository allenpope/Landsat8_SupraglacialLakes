%Need to manually script in Rinf values obtained through manual inspection
%Reads in sieved laked mask and band reflectances
%Goes through all methods described in Pope et al. (2015) and Pope (2016)
%Writes out lake depths    

%Define directory where Landsat scene folders are stored
directory = ' /Volumes/ELEMENTS/SermeqKujalleq2015/HighRez/';

%doesn't currently include any atmospheric corrections...

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

%Rinf values included from manual inspection
Rinf = [0.100, 0.060, 0.040, 0.051; ... % ... % [B2, B3, B4, B8] from down-path 006012166
    0.100, 0.060, 0.040, 0.057; ...'LC80060122015182LGN00'; ...
    0.095, 0.055, 0.033, 0.046; ...'LC80060122015198LGN00'; ...
    0.093, 0.051, 0.028, 0.042; ...'LC80060122015214LGN00'; ...
    0.098, 0.059, 0.040 0.052; ... 'LC80060132015166LGN00'
    0.097, 0.059, 0.039, 0.052; ... 'LC80060132015182LGN00'; ...
	0.089, 0.051, 0.031, 0.043; ... 'LC80060132015198LGN00'; ...
	0.086, 0.048, 0.028, 0.040; ...'LC80060132015214LGN00'; ...
    0.115, 0.072, 0.049, 0.063; ...'LC80060132015230LGN00'; ...
    0.104, 0.062, 0.040, 0.051; ... %'LC80060142015166LGN00'; ...
    0.112, 0.068, 0.046, 0.061; ...'LC80060142015182LGN00'; ...
	0.099, 0.058, 0.035, 0.050; ...'LC80060142015198LGN00'; ...
    0.093, 0.052, 0.029, 0.043; ... 'LC80060142015214LGN00'; ...
    0.100, 0.060, 0.034, 0.050; ...'LC80060152015166LGN00'; ...
	0.101, 0.056, 0.033, 0.048; ...'LC80060152015182LGN00'; ...
	0.099, 0.059, 0.033, 0.049; ...'LC80060152015198LGN00'; ...
    0.096, 0.051, 0.026, 0.042; ...'LC80060152015214LGN00'; ...
    0.090, 0.051, 0.030, 0.044; ...'LC80070122015189LGN00'; ...
    0.093, 0.050, 0.030, 0.041; ...'LC80070122015237LGN00'; ...
    0.089, 0.049, 0.028, 0.041; ...'LC80070132015189LGN00'; ...
    0.085, 0.048, 0.028, 0.041; ...'LC80070132015205LGN01'; ...
    0.096, 0.054, 0.032, 0.044; ...'LC80070132015237LGN00'; ...
    0.113, 0.066, 0.039, 0.055; ...'LC80070132015253LGN00'; ...
    0.083, 0.048, 0.027, 0.040; ...'LC80070142015189LGN00'; ...
    0.082, 0.045, 0.027, 0.038; ...'LC80070142015205LGN01'; ...
    0.095, 0.055, 0.034, 0.047; ...'LC80070142015237LGN00'; ...
    0.099, 0.052, 0.030, 0.043; ...'LC80070142015253LGN00'; ...
    0.096, 0.053, 0.030, 0.044; ... 'LC80080112015180LGN00'; ...
    0.097, 0.053, 0.031, 0.044; ...'LC80080112015196LGN00'; ...
    0.094, 0.051, 0.030, 0.043; ...'LC80080112015212LGN00'; ...
    0.097, 0.052, 0.031, 0.043; ...'LC80080112015228LGN00'; ...
    0.099, 0.060, 0.043, 0.055; ...'LC80080122015164LGN00'; ...
    0.091, 0.049, 0.026, 0.040; ...'LC80080122015180LGN00'; ...
    0.095, 0.054, 0.033, 0.046; ...'LC80080122015196LGN00'; ...
    0.090, 0.061, 0.039, 0.047; ...'LC80080122015212LGN00'; ...
    0.098, 0.049, 0.027, 0.041; ...'LC80090112015155LGN00'; ...
    0.095, 0.054, 0.033, 0.046; ...'LC80090112015187LGN00'; ...
    0.101, 0.056, 0.033, 0.046; ...'LC80090112015235LGN00'; ...
    0.099, 0.053, 0.031, 0.044; ...'LC80090112015251LGN00'; ...
    0.096, 0.051, 0.029, 0.042; ...'LC80090122015155LGN00'; ...
    0.091, 0.049, 0.028, 0.041; ...'LC80090122015171LGN00'; ...
    0.090, 0.049, 0.027, 0.041; ...'LC80090122015187LGN00'; ...
    0.097, 0.053, 0.031, 0.044; ... 'LC80090122015235LGN00'; ...
    0.103, 0.061, 0.039, 0.050; ...'LC80090122015251LGN00'; ...
    0.093, 0.049, 0.027, 0.040; ...'LC80100112015162LGN00'; ...
    0.105, 0.056, 0.032, 0.048; ...'LC80100112015194LGN00'; ...
    0.097, 0.050, 0.028, 0.042; ...'LC80100112015210LGN00'; ...
    0.097, 0.051, 0.029, 0.045]; %'LC80100112015226LGN00'};

%g values calculated according to Pope et al., 2015
G = [0.0178; 0.0341; 0.1413; 0.7507; 0.3817]; % OLI 1, 2, 3, 4, 8
        %Linearly interpolated the data provided in the papers/data 1nm
		%a: 2.5 nm resolution provided in Pope & Fry
		%b: 2 nm provided in Buiteveld
		%RSRs: 1nm provided by Ball / Landsat

home = pwd ;
addpath(pwd);

for scene = 1:size(Scenes,1);
    %change to appropriate directory
    expression = strcat('cd ',directory,Scenes{scene},'/');
    eval(expression);

    %read in sieved Lake Mask
    expression = strcat('[mask, mask_info] = geotiffread(''',Scenes{scene},'_lake_mask_sieve.tif'');');
    eval(expression);
    
    mask = mask(:,:,1);
    
    mask_thick = bwmorph(mask,'thicken',1);
    mask = bwmorph(mask_thick,'thin',1);
    mask_thick = double(mask_thick);
    mask = double(mask);

    
    %%Read in spectral files
    expression = strcat('tiffinfo = geotiffinfo(''',Scenes{scene},'_B4_ref.tif'');');
    eval(expression);

    expression = strcat('[B8_image, B8_image_info] = geotiffread(''',Scenes{scene},'_B8_ref.tif'');');
    eval(expression);

    expression = strcat('[B1_image, B1_image_info] = geotiffread(''',Scenes{scene},'_B1_ref.tif'');');
    eval(expression);

    %format files appropriately
    B8_image = double(B8_image);
    B8_image = B8_image/10000;
    B8_image = imresize(B8_image, size(B1_image),'bilinear'); %reduces image resolution, hopefully good enough for this...
        
    %%Method Band 8    
    %Assigning parameters
    rinf = Rinf(scene,4); %see above
    g = G(5); %Parameters are from Smith & Baker
    z = zeros(size(mask)); %pan

    %calculating lake-specific albedo
    CC = bwconncomp(mask_thick); %pan
    num_lakes = CC.NumObjects;
    Ad_lakes = zeros(num_lakes,1);

    lake_boundaries = bwboundaries(mask_thick,8,'noholes'); %pan

    for lake=1:num_lakes
        bound = lake_boundaries{lake};
        bound = sub2ind(size(mask),bound(:,1),bound(:,2)); %pan
        Ad_lakes(lake) = mean(B8_image(bound)); %full
    end

    CC = bwconncomp(mask); %pan
    props = regionprops(CC,mask,{'PixelIdxList'}); %pan
    Ad = zeros(size(mask)); %pan
    
    for lake = 1:num_lakes
        Ad(props(lake).PixelIdxList) = Ad_lakes(lake);
    end

    %filtering values which would cause a negative log
    temp = B8_image-rinf; %full
    index = find(temp>0);

    temp2 = Ad-rinf;
    index2 = find(temp2>0);

    index = intersect(index,index2);

    %calculating lake depth
    z(index) = (log(Ad(index)-rinf)-log(temp(index)))/(g);

    z_masked = mask.*z*1000; %can do this because the LakeMask is a 1/0 binary, written in mm %%pan

    mask_index = find(z_masked < 0); %filtering out negative lke depth values
    z_masked(mask_index) = 0;

    %write lake depths out
    z_masked(1,1) = 2^16-1;
    z_masked = uint16(z_masked);
    z_masked(1,1) = 0;
    expression = strcat('geotiffwrite(''',Scenes{scene},'_B8_depth.tif'', z_masked, B1_image_info, ''GeoKeyDirectoryTag'',tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
    eval(expression)
        
    %clean up
    clear B8_image B8_image_info z_masked expression index temp2 index2 temp Ad props CC Ad_lakes %B8_tiffinfo %B8_image_full
    clear bound lake_boundaries num_lakes g z B1_image_info
        
    %%Band4 method
    %read in spectral file
    expression = strcat('[image, image_info] = geotiffread(''',Scenes{scene},'_B4_ref.tif'');');
    eval(expression);
    expression = strcat('tiffinfo = geotiffinfo(''',Scenes{scene},'_B4_ref.tif'');');
    eval(expression);
        
    %format files appropriately
    image = double(image);
    image = image/10000;
    
    %Assigning parameters
    rinf = Rinf(scene,3); %see above
    g = G(4); %Parameters are from Smith & Baker
    z = zeros(size(mask));

    %calculating lake-specific albedo
    CC = bwconncomp(mask_thick);
    num_lakes = CC.NumObjects;
    Ad_lakes = zeros(num_lakes,1);

    lake_boundaries = bwboundaries(mask_thick,8,'noholes');

    for lake=1:num_lakes
        bound = lake_boundaries{lake};
        bound = sub2ind(size(mask),bound(:,1),bound(:,2));
        Ad_lakes(lake) = mean(image(bound));
    end

    CC = bwconncomp(mask);
    props = regionprops(CC,mask,{'PixelIdxList'}); 
    Ad = zeros(size(mask));
    
    for lake = 1:num_lakes
        Ad(props(lake).PixelIdxList) = Ad_lakes(lake);
    end

    %filtering values which would cause a negative log
    temp = image-rinf;
    index = find(temp>0);

    temp2 = Ad-rinf;
    index2 = find(temp2>0);

    index = intersect(index,index2);

    %calculating lake depth
    z(index) = (log(Ad(index)-rinf)-log(temp(index)))/(g);

    z_masked = mask.*z*1000; %can do this because the LakeMask is a 1/0 binary, written in mm

    mask_index = find(z_masked < 0); %filtering out negative lke depth values
    z_masked(mask_index) = 0;

    %write lake depths out
    z_masked(1,1) = 2^16-1;
    z_masked = uint16(z_masked);
    z_masked(1,1) = 0;
    expression = strcat('geotiffwrite(''',Scenes{scene},'_B4_depth.tif'', z_masked, image_info, ''GeoKeyDirectoryTag'',tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
    eval(expression)
        
    %clean up
    clear image image_info tiffinfo z_masked index temp2 index2 temp Ad props CC Ad_lakes
    clear bound lake_boundaries num_lakes g z 
    
    clear mask mask_thick mask_info expression lake mask_index rinf
end

expression = strcat('cd ''',home,'''');
eval(expression)

%%Averaging band4 and band 8 depths
for scene = 1:size(Scenes,1);
    %change to appropriate directory
    expression = strcat('cd ',directory,Scenes{scene},'/');
    eval(expression);
    
    %read in Band8
    expression = strcat('[B8, B8_info] = geotiffread(''',Scenes{scene},'_B8_depth.tif'');'); %depth1 = OLIg, depth = Sneedg
    eval(expression);
    expression = strcat('B8_tiffinfo = geotiffinfo(''',Scenes{scene},'_B8_depth.tif'');');
    eval(expression);

    %read in Band4
    expression = strcat('[B4, B4_info] = geotiffread(''',Scenes{scene},'_B4_depth.tif'');');
    eval(expression);
    expression = strcat('B4_tiffinfo = geotiffinfo(''',Scenes{scene},'_B4_depth.tif'');');
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

clear Scenes scene home expression Rinf G directory
%calculate stats later