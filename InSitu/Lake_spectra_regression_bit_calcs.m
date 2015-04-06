%Prepares data for the single band regressions
%Then regresses depths and convolved spectra to emulate single-band
    %satellite lake depth retrievals for a range of sensors.
%These data are the output in single_band_regression_stats.mat

%data doi: 10.5065/D6FQ9TN2

base = 'boat_spectral.';
days = {'july2.';'july3.'};
sats = {'etm_l';'etm_h';'oli';'wv2';'modis';'aster_hi';'aster_normal';'aster_lo'};

etm1_l = zeros(2290,1);
retm1_l=0;

etm2_l = zeros(2290,1);
retm2_l=0;

etm3_l = zeros(2290,1);
retm3_l=0;

etm1_h = zeros(2290,1);
retm1_h=0;

etm2_h = zeros(2290,1);
retm2_h=0;

etm3_h = zeros(2290,1);
retm3_h=0;

oli1 = zeros(2290,1);
roli1=0;

oli2 = zeros(2290,1);
roli2=0;

oli3 = zeros(2290,1);
roli3=0;

oli4 = zeros(2290,1);
roli4=0;

oli8 = zeros(2290,1);
roli8=0;

wv21 = zeros(2290,1);
rwv21=0;

wv22 = zeros(2290,1);
rwv22=0;

wv23 = zeros(2290,1);
rwv23=0;

wv24 = zeros(2290,1);
rwv24=0;

wv25 = zeros(2290,1);
rwv25=0;

wv26 = zeros(2290,1);
rwv26=0;

wv28 = zeros(2290,1);
rwv26=0;

wv27 = zeros(2290,1);
rwv26=0;

modis1 = zeros(2290,1);
rmodis1=0;

modis3 = zeros(2290,1);
rmodis3=0;

modis4 = zeros(2290,1);
rmodis4=0;

aster1_hi = zeros(2290,1);
raster1_hi=0;

aster2_hi = zeros(2290,1);
raster2_hi=0;

aster1_normal = zeros(2290,1);
raster1_normal=0;

aster2_normal = zeros(2290,1);
raster2_normal=0;

aster1_lo = zeros(2290,1);
raster1_lo=0;

aster2_lo = zeros(2290,1);
raster2_lo=0;

depth = zeros(2290,1);

for day = 1:2
	if day == 1
		for d=1:666
			dbase=strcat(base,days{day},'d',num2str(d),'.');
                        
            exp = strcat('depth(d) = ',dbase,'depth;');
            eval(exp);
            

			for sat=1:8
				satbase = strcat(dbase,sats(sat));
				if sat == 1
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    retm1_l = retm1_l+1;
                    etm1_l(retm1_l) = a;

					exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    retm2_l = retm2_l+1;
                    etm2_l(retm2_l) = a;

					exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    retm3_l = retm3_l+1;
                    etm3_l(retm3_l) = a;
                    
                elseif sat == 2
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    retm1_h = retm1_h+1;
                    etm1_h(retm1_h) = a;

					exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    retm2_h = retm2_h+1;
                    etm2_h(retm2_h) = a;

					exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    retm3_h = retm3_h+1;
                    etm3_h(retm3_h) = a;

                elseif sat == 3
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    roli1 = roli1+1;
                    oli1(roli1) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    roli2 = roli2+1;
                    oli2(roli2) = a;
                    
                    exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    roli3 = roli3+1;
                    oli3(roli3) = a;
                    
                    exp=strcat('a = ',satbase,'(4);');
					eval(exp{1});
                    roli4 = roli4+1;
                    oli4(roli4) = a;
                    
                    exp=strcat('a = ',satbase,'(5);');
					eval(exp{1});
                    roli8 = roli8+1;
                    oli8(roli8) = a;
                    
                elseif sat == 4
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    rwv21 = rwv21+1;
                    wv21(rwv21) = a;
                    
					exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    rwv22 = rwv22+1;
                    wv22(rwv22) = a;
                    
					exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    rwv23 = rwv23+1;
                    wv23(rwv23) = a;
                    
					exp=strcat('a = ',satbase,'(4);');
					eval(exp{1});
                    rwv24 = rwv24+1;
                    wv24(rwv24) = a;
                    
					exp=strcat('a = ',satbase,'(5);');
					eval(exp{1});
                    rwv25 = rwv25+1;
                    wv25(rwv25) = a;
                    
					exp=strcat('a = ',satbase,'(6);');
					eval(exp{1});
                    rwv26 = rwv26+1;
                    wv26(rwv26) = a;
                    
                    exp=strcat('a = ',satbase,'(7);');
					eval(exp{1});
                    rwv27 = rwv27+1;
                    wv27(rwv27) = a;
                    
                    exp=strcat('a = ',satbase,'(8);');
					eval(exp{1});
                    rwv28 = rwv28+1;
                    wv28(rwv28) = a;
                    
                elseif sat == 5
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    rmodis1 = rmodis1+1;
                    modis1(rmodis1) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    rmodis3 = rmodis3+1;
                    modis3(rmodis3) = a;
                    
                    exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    rmodis4 = rmodis4+1;
                    modis4(rmodis4) = a;
                    
                elseif sat == 6
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    raster1_hi = raster1_hi+1;
                    aster1_hi(raster1_hi) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    raster2_hi = raster2_hi+1;
                    aster2_hi(raster2_hi) = a;
                
                elseif sat == 7
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    raster1_normal = raster1_normal+1;
                    aster1_normal(raster1_normal) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    raster2_normal = raster2_normal+1;
                    aster2_normal(raster2_normal) = a;
                
                elseif sat == 8
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    raster1_lo = raster1_lo+1;
                    aster1_lo(raster1_lo) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    raster2_lo = raster2_lo+1;
                    aster2_lo(raster2_lo) = a;
                end
			end
		end
	elseif day == 2
		for d=1:1624
            dbase=strcat(base,days{day},'d',num2str(d),'.');
            
            exp = strcat('depth(d+666) = ',dbase,'depth;'); %666 because that's the number of measurements in day 1
            eval(exp);
            
			for sat=1:8
				satbase = strcat(dbase,sats(sat));
				if sat == 1
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    retm1_l = retm1_l+1;
                    etm1_l(retm1_l) = a;

					exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    retm2_l = retm2_l+1;
                    etm2_l(retm2_l) = a;

					exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    retm3_l = retm3_l+1;
                    etm3_l(retm3_l) = a;
                    
                elseif sat == 2
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    retm1_h = retm1_h+1;
                    etm1_h(retm1_h) = a;

					exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    retm2_h = retm2_h+1;
                    etm2_h(retm2_h) = a;

					exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    retm3_h = retm3_h+1;
                    etm3_h(retm3_h) = a;

                elseif sat == 3
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    roli1 = roli1+1;
                    oli1(roli1) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    roli2 = roli2+1;
                    oli2(roli2) = a;
                    
                    exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    roli3 = roli3+1;
                    oli3(roli3) = a;
                    
                    exp=strcat('a = ',satbase,'(4);');
					eval(exp{1});
                    roli4 = roli4+1;
                    oli4(roli4) = a;
                    
                    exp=strcat('a = ',satbase,'(5);');
					eval(exp{1});
                    roli8 = roli8+1;
                    oli8(roli8) = a;
                    
                elseif sat == 4
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    rwv21 = rwv21+1;
                    wv21(rwv21) = a;
                    
					exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    rwv22 = rwv22+1;
                    wv22(rwv22) = a;
                    
					exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    rwv23 = rwv23+1;
                    wv23(rwv23) = a;
                    
					exp=strcat('a = ',satbase,'(4);');
					eval(exp{1});
                    rwv24 = rwv24+1;
                    wv24(rwv24) = a;
                    
					exp=strcat('a = ',satbase,'(5);');
					eval(exp{1});
                    rwv25 = rwv25+1;
                    wv25(rwv25) = a;
                    
					exp=strcat('a = ',satbase,'(6);');
					eval(exp{1});
                    rwv26 = rwv26+1;
                    wv26(rwv26) = a;
                    
                    exp=strcat('a = ',satbase,'(7);');
					eval(exp{1});
                    rwv27 = rwv27+1;
                    wv27(rwv27) = a;
                    
                    exp=strcat('a = ',satbase,'(8);');
					eval(exp{1});
                    rwv28 = rwv28+1;
                    wv28(rwv28) = a;
                    
                elseif sat == 5
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    rmodis1 = rmodis1+1;
                    modis1(rmodis1) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    rmodis3 = rmodis3+1;
                    modis3(rmodis3) = a;
                    
                    exp=strcat('a = ',satbase,'(3);');
					eval(exp{1});
                    rmodis4 = rmodis4+1;
                    modis4(rmodis4) = a;
                    
                elseif sat == 6
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    raster1_hi = raster1_hi+1;
                    aster1_hi(raster1_hi) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    raster2_hi = raster2_hi+1;
                    aster2_hi(raster2_hi) = a;
                
                elseif sat == 7
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    raster1_normal = raster1_normal+1;
                    aster1_normal(raster1_normal) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    raster2_normal = raster2_normal+1;
                    aster2_normal(raster2_normal) = a;
                
                elseif sat == 8
					exp=strcat('a = ',satbase,'(1);');
					eval(exp{1});
                    raster1_lo = raster1_lo+1;
                    aster1_lo(raster1_lo) = a;
                    
                    exp=strcat('a = ',satbase,'(2);');
					eval(exp{1});
                    raster2_lo = raster2_lo+1;
                    aster2_lo(raster2_lo) = a;
                end
			end
		end
	end
end

index = find(depth<50); %anything higher is really in cm, not m - getting rid of depths <1 m
depth = depth(index);
etm1_l = etm1_l(index);
etm1_h = etm1_h(index);
etm2_l = etm2_l(index);
etm2_h = etm2_h(index);
etm3_l = etm3_l(index);
etm3_h = etm3_h(index);
oli1 = oli1(index);
oli2 = oli2(index);
oli3 = oli3(index);
oli4 = oli4(index);
oli8 = oli8(index);
wv21 = wv21(index);
wv22 = wv22(index);
wv23 = wv23(index);
wv24 = wv24(index);
wv25 = wv25(index);
wv26 = wv26(index);
wv27 = wv27(index);
wv28 = wv28(index);
modis1 = modis1(index);
modis3 = modis3(index);
modis4 = modis4(index);
aster1_hi = aster1_hi(index);
aster1_normal = aster1_normal(index);
aster1_lo = aster1_lo(index);
aster2_hi = aster2_hi(index);
aster2_normal = aster2_normal(index);
aster2_lo = aster2_lo(index);

clear base d day days dbase exp sat satbase sats retm1_l retm2_l retm3_l roli1
clear roli2 roli3 roli4 roli8 rwv21 rwv22 rwv23 rwv24 rwv25 rwv26 rmodis1
clear rmodis3 rmodis4 raster1_hi raster2_hi a index raster1_lo raster2_lo
clear retm1_h retm2_h retm3_h raster1_normal raster2_normal b

satbands = {'etm1_l'; 'etm2_l'; 'etm3_l'; 'etm1_h'; 'etm2_h'; 'etm3_h';'oli1'; 'oli2'; 'oli3'; 'oli4'; 'oli8'; 'modis1'; 'modis3'; 'modis4'; 'wv21'; 'wv22'; 'wv23'; 'wv24'; 'wv25'; 'wv26'; 'wv27'; 'wv28'; 'aster1_hi'; 'aster2_hi'; 'aster1_normal'; 'aster2_normal'; 'aster1_lo'; 'aster2_lo'};

for a = 1:28; %28 bands being investigated

    satband = satbands(a);
    expr = strcat('ref = ',satband(1),';');
    eval(expr{1});

    ft = fittype('a + b*exp(-c*x)');
        %a = R deep water
        %b = BottomAlbedo - RDeepWater
        %c = g...
    fo = fitoptions('Method','NonlinearLeastSquares','Lower',[0,0,0],'Upper',[1,1,1],'StartPoint',[0.002,0.275,0.023]); %
    [curve] = fit(depth,ref,ft,fo);
    
    %strip info about the curve
    Ad = curve.a + curve.b;
    Rinf = curve.a;
    g = curve.c;
    confidence = confint(curve);
    confidence_Rinf = confidence(:,1);
    confidence_Ad = confidence(:,2);
    confidence_g = confidence(:,3);
    
    %write a text file to plot original data
    forplot = [depth ref];
    dlmwrite(strcat(satband{1},'_data.txt'), forplot);
             
    %calc curve for plotting, and write text file for it
    domain_z = 1:.1:5;
    domain_z = domain_z';
    curve_forplot = curve.a + curve.b*exp(-curve.c*domain_z);
    curve_forplot = [domain_z curve_forplot];
    dlmwrite(strcat(satband{1},'_curve.txt'), curve_forplot);
    
    %for all input R, calc z
    depth_calc = (log(ref - Rinf) - log(Ad-Rinf))/(-g);
        
    %calc min, max, mean, std dev, median, Q1, Q3
    minimum = min(depth_calc);
    maximum = max(depth_calc);
    mean_calc = mean(depth_calc);
    std_dev = std(depth_calc);
    q1 = quantile(depth_calc,.25);
    median = quantile(depth_calc,.5);
    q3 = quantile(depth_calc,.75);
    
    %calc error, RMSE, correlation
    error = depth_calc-depth;
    error_std = std(error);
    RMSE = (sum(error.*error)/2226)^.5; %2226 is the known sample size here
    correlation = corrcoef(depth_calc, depth);
    correlation = correlation(2);
    
    temp = struct('depth_sonar',depth,'R',ref,'Ad',Ad,'confidence_Ad',confidence_Ad,'Rinf',Rinf,'confidence_Rinf',confidence_Rinf,'g',g,'confidence_g',confidence_g,'Curve',curve_forplot','depth_calc',depth_calc,'min',minimum,'max',maximum,'mean',mean_calc,'std',std_dev,'q1',q1,'median',median,'q3',q3,'error',error,'error_std',error_std,'RMSE',RMSE,'r',correlation);
    expr=strcat(satband(1),'_stats = temp;'); 
    eval(expr{1});
    
end
clear minimum maximum mean_calc  RMSE correlation temp expr depth_calc 
clear name curve_forplot domain_z ref satband satbands confidence a ans
clear Ad Rinf g curve fo ft forplot std_dev q1 median q3 error error_std
clear confidence_Ad confidence_Rinf confidence_g confidence b r
