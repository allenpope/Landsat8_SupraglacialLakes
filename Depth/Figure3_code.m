%Plotting Figure 3 using NW lake depth data

%Creating plot directly from stored data, 
%doi: 10.6084/m9.figshare.1367639
%including '*30*30/1000' to go from depth to volume
%Do not repeat this step twice!

%Code to create Figure 3 from available data
%cd ~/_______NWDepths/ %change to appropriate directory

%Creating blank spaces for day of year for each type of lake depth
Band3 = [183, 199, 215, 231; 0, 0, 0, 0];
Band4 = [183, 199, 215, 231; 0, 0, 0, 0];
Band8 = [183, 199, 215, 231; 0, 0, 0, 0];
Band13 = [183, 199, 215, 231; 0, 0, 0, 0];
Band18 = [183, 199, 215, 231; 0, 0, 0, 0];
Band23 = [183, 199, 215, 231; 0, 0, 0, 0];
Band48 = [183, 199, 215, 231; 0, 0, 0, 0];

Band3(2,1) = sum(sum(imread('NW_183_Band3_depth.tif')))*30*30/1000;
Band3(2,2) = sum(sum(imread('NW_199_Band3_depth.tif')))*30*30/1000;
Band3(2,3) = sum(sum(imread('NW_215_Band3_depth.tif')))*30*30/1000;
Band3(2,4) = sum(sum(imread('NW_231_Band3_depth.tif')))*30*30/1000;

Band4(2,1) = sum(sum(imread('NW_183_Band4_depth.tif')))*30*30/1000;
Band4(2,2) = sum(sum(imread('NW_199_Band4_depth.tif')))*30*30/1000;
Band4(2,3) = sum(sum(imread('NW_215_Band4_depth.tif')))*30*30/1000;
Band4(2,4) = sum(sum(imread('NW_231_Band4_depth.tif')))*30*30/1000;

Band8(2,1) = sum(sum(imread('NW_183_Band8_depth.tif')))*30*30/1000;
Band8(2,2) = sum(sum(imread('NW_199_Band8_depth.tif')))*30*30/1000;
Band8(2,3) = sum(sum(imread('NW_215_Band8_depth.tif')))*30*30/1000;
Band8(2,4) = sum(sum(imread('NW_231_Band8_depth.tif')))*30*30/1000;

Band13(2,1) = sum(sum(imread('NW_183_Band13_depth.tif')))*30*30/1000;
Band13(2,2) = sum(sum(imread('NW_199_Band13_depth.tif')))*30*30/1000;
Band13(2,3) = sum(sum(imread('NW_215_Band13_depth.tif')))*30*30/1000;
Band13(2,4) = sum(sum(imread('NW_231_Band13_depth.tif')))*30*30/1000;

Band18(2,1) = sum(sum(imread('NW_183_Band18_depth.tif')))*30*30/1000;
Band18(2,2) = sum(sum(imread('NW_199_Band18_depth.tif')))*30*30/1000;
Band18(2,3) = sum(sum(imread('NW_215_Band18_depth.tif')))*30*30/1000;
Band18(2,4) = sum(sum(imread('NW_231_Band18_depth.tif')))*30*30/1000;

Band23(2,1) = sum(sum(imread('NW_183_Band23_depth.tif')))*30*30/1000;
Band23(2,2) = sum(sum(imread('NW_199_Band23_depth.tif')))*30*30/1000;
Band23(2,3) = sum(sum(imread('NW_215_Band23_depth.tif')))*30*30/1000;
Band23(2,4) = sum(sum(imread('NW_231_Band23_depth.tif')))*30*30/1000;

Band48(2,1) = sum(sum(imread('NW_183_Band48_depth.tif')))*30*30/1000;
Band48(2,2) = sum(sum(imread('NW_199_Band48_depth.tif')))*30*30/1000;
Band48(2,3) = sum(sum(imread('NW_215_Band48_depth.tif')))*30*30/1000;
Band48(2,4) = sum(sum(imread('NW_231_Band48_depth.tif')))*30*30/1000;

plot(Band3(1,:),Band3(2,:))
hold on
plot(Band4(1,:),Band3(2,:))
plot(Band8(1,:),Band3(2,:))
plot(Band13(1,:),Band3(2,:))
plot(Band18(1,:),Band3(2,:))
plot(Band23(1,:),Band3(2,:))
plot(Band48(1,:),Band3(2,:))
