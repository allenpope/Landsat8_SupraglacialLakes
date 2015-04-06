%Need to manually script in Rinf values obtained through manual inspection
%Reads in sieved laked mask
%Goes through all methods described in Pope et al. (2015)
%Writes out lake depths    

%Make sure TwobandDepth.m is in an active folder
%Calling this requires the MATLAB Optimization Toolbox

%Define directory where Landsat scene folders are stored
directory = ' ~/Google'' Drive''/LandsatLakes/';

%doesn't currently include any atmospheric corrections...

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

%Rinf values included from manual inspection
Rinf = [0.075, 0.041, 0.023, 0.034;% ... % [B2, B3, B4, B8]
    0.092, 0.050, 0.028, 0.042; ...
    0.090, 0.048, 0.025, 0.040; ...
    0.075, 0.041, 0.023, 0.034; ...
    0.092, 0.050, 0.028, 0.042; ...
    0.091, 0.049, 0.026, 0.039;...
    0.090, 0.048, 0.025, 0.040; ...
    0.075, 0.041, 0.023, 0.034; ...
    0.092, 0.050, 0.028, 0.042; ...
    0.075, 0.041, 0.023, 0.034; ...
    0.090, 0.048, 0.025, 0.040; ...
    0.075, 0.041, 0.023, 0.034; ...
    0.092, 0.050, 0.028, 0.042; ...
    0.094, 0.051, 0.026, 0.039; ... 
    0.097, 0.053, 0.031, 0.044; ...
    0.097, 0.053, 0.031, 0.044; ...
    0.081, 0.045, 0.024, 0.036; ...
    0.097, 0.053, 0.031, 0.044; ...
    0.101, 0.061, 0.028, 0.049; ...
    0.099, 0.053, 0.029, 0.043; ...
    0.101, 0.061, 0.028, 0.049; ...
    0.099, 0.053, 0.029, 0.043; ...
    0.085, 0.045, 0.025, 0.038; ...
    0.104, 0.062, 0.037, 0.052; ...
    0.094, 0.051, 0.029, 0.042; ...
    0.084, 0.047, 0.024, 0.037; ...
    0.095, 0.050, 0.027, 0.041; ...
    0.088, 0.049, 0.026, 0.040; ...
    0.132, 0.084, 0.057, 0.078; ...
    0.099, 0.054, 0.030, 0.045; ...
    0.103, 0.057, 0.033, 0.047]; 

%g values calculated according to Pope et al., 2015
G = [0.0178; 0.0341; 0.1413; 0.7507; 0.3817]; % OLI 1, 2, 3, 4, 8
        %Linearly interpolated the data provided in the papers/data 1nm
		%a: 2.5 nm resolution provided in Pope & Fry
		%b: 2 nm provided in Buiteveld
		%RSRs: 1nm provided by Ball / Landsat

home = pwd ;
addpath(pwd);

for scene = 1:1;%size(Scenes,1);
    %change to appropriate directory
    expression = strcat('cd ',directory,Scenes{scene},'/');
    eval(expression);

    %read in sieved Lake Mask
    expression = strcat('[mask, mask_info] = geotiffread(''',Scenes{scene},'_lake_mask_sieve.tif'');');
    eval(expression);
    
    mask_thick = bwmorph(mask,'thicken',1);
    mask = bwmorph(mask_thick,'thin',1);
    mask_thick = double(mask_thick);
    mask = double(mask);

    
    %%Start with Method 2-3
    %read in spectral files
    expression = strcat('[B2_image, B2_image_info] = geotiffread(''',Scenes{scene},'_B2_ref.tif'');');
    eval(expression);
    expression = strcat('[B3_image, B3_image_info] = geotiffread(''',Scenes{scene},'_B3_ref.tif'');');
    eval(expression);
    expression = strcat('tiffinfo = geotiffinfo(''',Scenes{scene},'_B3_ref.tif'');');
    eval(expression);
    
    %format files appropriately
    B2_image = double(B2_image);
    B2_image = B2_image/10000;
    B3_image = double(B3_image);
    B3_image = B3_image/10000;
    
    %setting parameters
    global g1 g2 Rw1 Rw2 Rinf1 Rinf2 Ri1 Ri2 Rc1 Rc2
    z = zeros(size(B2_image));
    
    g1 = G(2);
    g2 = G(3);
    
    Rinf1 = Rinf(scene, 1);
    Rinf2 = Rinf(scene, 2);
    Ri1 = .7721; %from Langjokull
    Ri2 = .7756; %from Langjokull
    Rc1 = .0793; %from Langjokull
    Rc2 = .0816; %from Langjokull

    index = find(mask);
    length = size(index,1);

    for i=1:length;
        Rw1 = B2_image(index(i));
        Rw2 = B3_image(index(i));
        fsolve(@TwoBandDepth,0); %should be in same directory as this script
        ri = ans;
   
        Ad1 = ri*Ri1+(1-ri)*Rc1;
        z(index(i))=(log(Rw1-Rinf1)-log(Ad1-Rinf1))/-g1; 
    end
    
    %write out lake depths
    z = z*1000; %to mm and better for compression
    z(1) = 2^16-1;
    z = uint16(z);
    z(1) = 0;
    expression = strcat('geotiffwrite(''',Scenes{scene},'_B23_depth.tif'', z, B2_image_info, ''GeoKeyDirectoryTag'',tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
    eval(expression)
    
    clear Rinf1 Rinf2 g1 g2 Rc1 Rc2 Rw1 Rw2 ri z expression Ad1
    clear B2_image B2_image_info index length i
    
    
    
    %%Next to B3 method itself
    %Don't need to read in spectral file - already there
    %Assigning parameters
    rinf = Rinf(scene,2); %see above
    g = G(3); %Parameters are from Smith & Baker
    z = zeros(size(mask));

    %calculating lake-specific albedo
    CC = bwconncomp(mask_thick);
    num_lakes = CC.NumObjects;
    Ad_lakes = zeros(num_lakes,1);

    lake_boundaries = bwboundaries(mask_thick,8,'noholes');

    for lake=1:num_lakes
        bound = lake_boundaries{lake};
        bound = sub2ind(size(mask),bound(:,1),bound(:,2));
        Ad_lakes(lake) = mean(B3_image(bound));
    end

    CC = bwconncomp(mask);
    props = regionprops(CC,mask,{'PixelIdxList'}); 
    Ad = zeros(size(mask));
    
    for lake = 1:num_lakes
        Ad(props(lake).PixelIdxList) = Ad_lakes(lake);
    end

    %filtering values which would cause a negative log
    temp = B3_image-rinf;
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
    expression = strcat('geotiffwrite(''',Scenes{scene},'_B3_depth.tif'', z_masked, B3_image_info, ''GeoKeyDirectoryTag'',tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
    eval(expression)
        
    %clean up
    clear z_masked expression index temp2 index2 temp Ad props CC Ad_lakes
    clear bound lake_boundaries num_lakes g z
    
    %%Method 13    
    %read in spectral files
    expression = strcat('[B1_image, B1_image_info] = geotiffread(''',Scenes{scene},'_B1_ref.tif'');');
    eval(expression);
    
    %format files appropriately
    B1_image = double(B1_image);
    B1_image = B1_image/10000;
        
    %calculating lake depth
    a = 0.1488; %Parameter from earlier regression
    b = 5.0370; %Parameter from earlier regression
    c = 5.0473; %Parameter from earlier regression
    X = log(B1_image./B3_image); 
    z = a + b*X + c*X.*X;
    z_masked = mask.*z*1000; %can do this because the LakeMask is a 1/0 binary, written in mm

    mask_index = find(z_masked < 0); %filtering out negative lke depth values
    z_masked(mask_index) = 0;
    
    %write out lake depths
    z_masked(1,1) = 2^16-1;
    z_masked = uint16(z_masked);
    z_masked(1,1) = 0;
    expression = strcat('geotiffwrite(''',Scenes{scene},'_B13_depth.tif'', z_masked, B1_image_info, ''GeoKeyDirectoryTag'',tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
    eval(expression)
        
    %clean up
    clear z_masked expression B3_image B3_image_info a b c X z
    
    
    %%Method 18
    %read in spectral file
    expression = strcat('[B8_image, B8_image_info] = geotiffread(''',Scenes{scene},'_B8_ref.tif'');');
    eval(expression);
    %expression = strcat('B8_tiffinfo = geotiffinfo(''',Scenes{scene},'_B8_ref.tif'');');
    %eval(expression);

    %format files appropriately
    B8_image = double(B8_image);
    B8_image = B8_image/10000;
    %B8_image_full = B8_image;
    B8_image = imresize(B8_image, size(B1_image),'bilinear'); %reduces image resolution, hopefully good enough for this...
        
    %calculating lake depth
    a = 1.6240; %Parameter from earlier regression
    b = -5.9696; %Parameter from earlier regression
    c = 12.4983; %Parameter from earlier regression
    X = log(B1_image./B8_image); 
    z = a + b*X + c*X.*X;
    z_masked = mask.*z*1000; %can do this because the LakeMask is a 1/0 binary, written in mm

    mask_index = find(z_masked < 0); %filtering out negative lke depth values
    z_masked(mask_index) = 0;
    
    %write out lake depths
    z_masked(1,1) = 2^16-1;
    z_masked = uint16(z_masked);
    z_masked(1,1) = 0;
    expression = strcat('geotiffwrite(''',Scenes{scene},'_B18_depth.tif'', z_masked, B1_image_info, ''GeoKeyDirectoryTag'',tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
    eval(expression)
        
    %clean up
    clear B1_image z_masked expression a b c X z %B8_image B1_image_info tiffinfo 

    %%Method Band 8    
    %creating appropriate mask
    %mask_pan = imresize(mask, size(B8_image_full),'nearest');
    %mask_thick_pan = imresize(mask_thick, size(B8_image_full),'nearest');
    
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

clear Scenes scene home expression Rinf G
%calculate stats later