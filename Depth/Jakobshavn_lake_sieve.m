%Removes small lakes (<5 pixels) and linear features

%Define directory where Landsat scene folders are stored
directory = ' ~/Google'' Drive''/LandsatLakes/';

%"Lakes" must be at least 5 pixels total
min_pixel = 5;

%"Lakes" must be wider and/or taller than 1 pixels
min_width = 1;

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
    
    %read in Lake Mask
    expression = strcat('[mask, mask_info] = geotiffread(''',Scenes{scene},'_lake_mask.tif'');');
    eval(expression);
    expression = strcat('mask_tiffinfo = geotiffinfo(''',Scenes{scene},'_lake_mask.tif'');');
    eval(expression);

    %remove "small" lakes
    CC = bwconncomp(mask,4);
    for lake = 1:CC.NumObjects
        if size(CC.PixelIdxList{lake},1) < min_pixel
            mask(CC.PixelIdxList{lake}) = 0;
        else %all same row or all same column
            [r,c] = ind2sub(size(mask),CC.PixelIdxList{lake});
            r = unique(r);
            c = unique(c);
            if size(r,1) == min_width || size(c,1) == min_width;
                mask(CC.PixelIdxList{lake}) = 0;
            end
        end
    end
    
    %write mask_sieve
    expression = strcat('geotiffwrite(''',Scenes{scene},'_lake_mask_sieve.tif'', mask, mask_info, ''GeoKeyDirectoryTag'',mask_tiffinfo.GeoTIFFTags.GeoKeyDirectoryTag);');
    eval(expression)
    
    clear mask mask_info mask_tiffinfo CC lake expression r c
end

expression = strcat('cd ''',home,'''');
eval(expression)

clear home Scenes scene expression