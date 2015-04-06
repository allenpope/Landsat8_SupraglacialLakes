%Plotting Figure 5 using Sermeq Kujalleq data

%Creating plot directly from stored data, 
%doi: 10.6084/m9.figshare.1328577
%including '*30*30/1000' to go from depth to volume
%Do not repeat this step twice!

%Code to plot Figure 5a
%cd ~/____/LakeDepths/ %change to appropriate directory

%putting dates with available spaces for water volumes
%in theory, would be possible to easily automate/parse this,
%but to be explicit, I am hard-coding for these data explicitly
x010011 = [159, 207, 223, 239; 0, 0, 0, 0];
x009011 = [168, 184, 200, 216; 0, 0, 0, 0];
x009012 = [168, 184, 216; 0, 0, 0];
x008011 = [161, 193; 0, 0];
x008012 = [161, 193; 0, 0];
x007012 = [218; 0];
x007013 = [218; 0];
x007014 = [170, 218; 0, 0];
x006012 = [195, 211; 0, 0];
x006013 = [163, 195, 211, 243; 0, 0, 0, 0];
x006014 = [163, 195, 211, 243; 0, 0, 0, 0];
x006015 = [163, 195, 211, 243; 0, 0, 0, 0];

x010011(2,1) = sum(sum(imread('LC80100112014159LGN00_B48_depth1.tif')))*30*30/1000;
x010011(2,2) = sum(sum(imread('LC80100112014207LGN00_B48_depth1.tif')))*30*30/1000;
x010011(2,3) = sum(sum(imread('LC80100112014223LGN00_B48_depth1.tif')))*30*30/1000;
x010011(2,4) = sum(sum(imread('LC80100112014239LGN00_B48_depth1.tif')))*30*30/1000;

x009011(2,2) = sum(sum(imread('LC80090112014184LGN00_B48_depth1.tif')))*30*30/1000;
x009011(2,3) = sum(sum(imread('LC80090112014200LGN00_B48_depth1.tif')))*30*30/1000;
x009011(2,4) = sum(sum(imread('LC80090112014216LGN00_B48_depth1.tif')))*30*30/1000;

x009012(2,2) = sum(sum(imread('LC80090122014184LGN00_B48_depth1.tif')))*30*30/1000;
x009012(2,3) = sum(sum(imread('LC80090122014216LGN00_B48_depth1.tif')))*30*30/1000;

x008011(2,1) = sum(sum(imread('LC80080112014161LGN00_B48_depth1.tif')))*30*30/1000;
x008011(2,2) = sum(sum(imread('LC80080112014193LGN01_B48_depth1.tif')))*30*30/1000;

x008012(2,1) = sum(sum(imread('LC80080122014161LGN00_B48_depth1.tif')))*30*30/1000;
x008012(2,2) = sum(sum(imread('LC80080122014193LGN01_B48_depth1.tif')))*30*30/1000;

x007012(2,1) = sum(sum(imread('LC80070122014218LGN00_B48_depth1.tif')))*30*30/1000;

x007013(2,1) = sum(sum(imread('LC80070132014218LGN00_B48_depth1.tif')))*30*30/1000;

x007014(2,1) = sum(sum(imread('LC80070142014170LGN00_B48_depth1.tif')))*30*30/1000;
x007014(2,2) = sum(sum(imread('LC80070142014218LGN00_B48_depth1.tif')))*30*30/1000;

x006012(2,1) = sum(sum(imread('LC80060122014195LGN00_B48_depth1.tif')))*30*30/1000;
x006012(2,2) = sum(sum(imread('LC80060122014211LGN00_B48_depth1.tif')))*30*30/1000;

x006013(2,1) = sum(sum(imread('LC80060132014163LGN00_B48_depth1.tif')))*30*30/1000;
x006013(2,2) = sum(sum(imread('LC80060132014195LGN00_B48_depth1.tif')))*30*30/1000;
x006013(2,3) = sum(sum(imread('LC80060132014211LGN00_B48_depth1.tif')))*30*30/1000;
x006013(2,4) = sum(sum(imread('LC80060132014243LGN00_B48_depth1.tif')))*30*30/1000;

x006014(2,1) = sum(sum(imread('LC80060142014163LGN00_B48_depth1.tif')))*30*30/1000;
x006014(2,2) = sum(sum(imread('LC80060142014195LGN00_B48_depth1.tif')))*30*30/1000;
x006014(2,3) = sum(sum(imread('LC80060142014211LGN00_B48_depth1.tif')))*30*30/1000;
x006014(2,4) = sum(sum(imread('LC80060142014243LGN00_B48_depth1.tif')))*30*30/1000;

x006015(2,1) = sum(sum(imread('LC80060152014163LGN00_B48_depth1.tif')))*30*30/1000;
x006015(2,2) = sum(sum(imread('LC80060152014195LGN00_B48_depth1.tif')))*30*30/1000;
x006015(2,3) = sum(sum(imread('LC80060152014211LGN00_B48_depth1.tif')))*30*30/1000;
x006015(2,4) = sum(sum(imread('LC80060152014243LGN00_B48_depth1.tif')))*30*30/1000;

plot(x010011(1,:),x010011(2,:))
hold on
plot(x009011(1,:),x009011(2,:))
plot(x009012(1,:),x009012(2,:))
plot(x008011(1,:),x008011(2,:))
plot(x008012(1,:),x008012(2,:))
scatter(x007012(1,:),x007012(2,:))
scatter(x007013(1,:),x007013(2,:))
plot(x007014(1,:),x007014(2,:))
plot(x006012(1,:),x006012(2,:))
plot(x006013(1,:),x006013(2,:))
plot(x006014(1,:),x006014(2,:))
plot(x006015(1,:),x006015(2,:))
hold off

%To plot Figure 5b
plot(x007014(1,:),x007014(2,:))
hold on
plot(x010011(1,:),x010011(2,:))
plot(x006015(1,:),x006015(2,:))
hold off

%To plot Figure 5c
plot(x008011(1,:),x008011(2,:))
hold on
plot(x008012(1,:),x008012(2,:))
hold off

%To plot Figure 5d
plot(x006012(1,:),x006012(2,:))
hold on
plot(x006013(1,:),x006013(2,:))
plot(x006014(1,:),x006014(2,:))
plot(x006015(1,:),x006015(2,:))
hold off