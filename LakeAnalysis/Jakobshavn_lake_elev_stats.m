%Takes elevation information from GIMP DEM reprojected for each scene 
%(i.e. "*_gimp.tif") and depth information 
    %Calculates statistics from these two data inputs

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

lakes = zeros(1,6);

for scene = 1:size(Scenes,1);
    %change to appropriate directory
    expression = strcat('cd ',directory,Scenes{scene},'/');
    eval(expression);

    %read in depths
    expression = strcat('[depth, depth_info] = geotiffread(''',Scenes{scene},'_B48_depth1.tif'');');
    eval(expression);
    
    %read in GIMP elevations
    expression = strcat('[elev, elev_info] = geotiffread(''',Scenes{scene},'_gimp.tif'');');
    eval(expression);
    
    %extracting and recording DOY
    date = Scenes(scene);
    date = char(date);
    date = date(14:16);
    date = str2num(date);
    
    %extracting and recording row
    row = Scenes(scene);
    row = char(row);
    row = row(4:6);
    row = str2num(row);

    %extracting and recording path
    path = Scenes(scene);
    path = char(path);
    path = path(7:9);
    path = str2num(path);

    %get lake depths and record info
    index = find(depth);
    
    temp = zeros(size(index,1),5);
    temp(:,1) = depth(index);
    temp(:,2) = elev(index);
    temp(:,3) = date;
    temp(:,4) = row;
    temp(:,5) = path;
    temp(:,6) = index;
    
    %records new scene info
    lakes = [lakes; temp];
    
    %get hypsometry in some way
    h = hist(depth(find(depth)),[0:100:10000]); %units are in pixels
        
    expression = strcat(Scenes{scene},'= h;');
    eval(expression);
end

lakes(1,:) = [];

expression = strcat('cd ''',home,'''');
eval(expression)

depths_in_mm = 0:100:10000;

%total = LC80060132014243LGN00+LC80060142014243LGN00+LC80060152014243LGN00+LC80060122014195LGN00+LC80060122014211LGN00+LC80060132014163LGN00+LC80060132014195LGN00+LC80060132014211LGN00+LC80060142014163LGN00+LC80060142014195LGN00+LC80060142014211LGN00+LC80060152014163LGN00+LC80060152014195LGN00+LC80060152014211LGN00+LC80070122014218LGN00+LC80070132014218LGN00+LC80070142014170LGN00+LC80070142014218LGN00+LC80080112014161LGN00+LC80080112014193LGN01+LC80080122014161LGN00+LC80080122014193LGN01+LC80090112014184LGN00+LC80090112014200LGN00+LC80090112014216LGN00+LC80090122014184LGN00+LC80090122014216LGN00+LC80100112014159LGN00+LC80100112014207LGN00+LC80100112014223LGN00+LC80100112014239LGN00;
expression = strcat('total =',Scenes{1});
for scene = 2:size(Scenes,1);
    expression = strcat(expression,'+',Scenes{scene});
end
expression = strcat(expression,';');
eval(expression)

clear home Scenes scene expression path row date temp index depth elev depth_info elev_info h

save Jakobs_lake_elev_depth_stats

%take stats from all dates based on elevation
avg_depth= zeros(1825,2);
max_depth = zeros(1825,2);
avg_depth(:,1) = 331:1:2155; %the min and max elevations measured by GIMP
max_depth(:,1) = 331:1:2155;


for elev = 331:2155 
   index = find(lakes(:,2)==elev);
   if size(index,1) > 1
       avg_depth(elev-330,2) = mean(lakes(index,1));
       max_depth(elev-330,2) = max(lakes(index,1));
   end
end

clear elev index

save Jakobs_lake_elev_depth_stats

%Can plot all depth vs elevation
scatter(max_depth(:,1),max_depth(:,2)/1000); %plots figure 6b
plot(depths_in_mm/1000,total); %plots figure 6a

%Breakdown relationship between depths, etc. 
days = unique(lakes(:,3));
avg_depth_days = nan(1825,size(days,1));
max_depth_days = nan(1825,size(days,1));

for day = 1:size(days,1)
    for elev = 331:2155 
        elev
        index = intersect(find(lakes(:,2)==elev),find(lakes(:,3)==days(day)));
        if size(index,1) > 1
            avg_depth_days(elev-330,day) = mean(lakes(index,1));
            max_depth_days(elev-330,day) = max(lakes(index,1));
        end
    end
end

clear day elev index
save Jakobs_lake_elev_depth_stats
