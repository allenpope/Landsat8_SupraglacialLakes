%Takes elevation information from GIMP DEM reprojected for each scene 
%(i.e. "*_gimp.tif") and depth information 
    %Calculates statistics from these two data inputs

%Define directory where Landsat scene folders are stored
directory = ' /Volumes/ELEMENTS/SermeqKujalleq2015/HighRez/';

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

depths_in_mm = 0:100:10000;

expression = strcat('total =',Scenes{1});
for scene = 2:size(Scenes,1);
    expression = strcat(expression,'+',Scenes{scene});
end
expression = strcat(expression,';');
eval(expression)

clear Scenes scene expression path row date temp index depth elev depth_info elev_info h

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

%Add which day of year for each max depth
max_depth = [max_depth, zeros(1825,1)];
for elev = 331:2155 
    elev
    index = find(lakes(:,2)==elev);
    if size(index,1) > 1 
       index = intersect(find(lakes(:,1)==max_depth(elev-330,2)),find(lakes(:,2)==elev)); %col 3 is DOY
       max_depth(elev-330,3) = lakes(index(1),3);
    end
end

%replacing zeros in plot
max_depth(find(max_depth==0)) = nan;

clear elev index

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

%Can plot all depth vs elevation
figure();
scatter(max_depth(:,1),max_depth(:,2),20,max_depth(:,3),'filled'); %plots figure 6b
colorbar;

figure();
plot(depths_in_mm/1000,total); %plots figure 6a


expression = strcat('cd ''',home,'''');
eval(expression);

clear day elev index home directory 
save Jakobs_lake_elev_depth_stats