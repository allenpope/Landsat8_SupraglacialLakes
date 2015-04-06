%Regresses depths and convolved spectra to emulate band-ratio
    %satellite lake depth retrievals for a range of sensors. A wider
    %investigation of WorldView-2 bands (see Moussavi et al., 2015 - RSE)
    %is conducted with method2_wv2_revised.m. All data are stored in
    %two_band_regression_stats.mat
%data doi: 10.5065/D6FQ9TN2

%need to have loaded from for_method_2 all band reflectances & depth

band1 = [wv21 wv21 wv21 wv21 wv21 wv21 wv21 wv22 wv22 wv22 wv22 wv22 wv22 wv23 wv23 wv23 wv23 wv23 wv24 wv24 wv24 wv24 wv25 wv25 wv25 wv26 wv26 wv27]; %lower band wavelength
band2 = [wv22 wv23 wv24 wv25 wv26 wv27 wv28 wv23 wv24 wv25 wv26 wv27 wv28 wv24 wv25 wv26 wv27 wv28 wv25 wv26 wv27 wv28 wv26 wv27 wv28 wv27 wv28 wv28]; %higher band wavelength
scenario_name = {'WV2_12' 'WV2_13' 'WV2_14' 'WV2_15' 'WV2_16' 'WV2_17' 'WV2_18' 'WV2_23' 'WV2_24' 'WV2_25' 'WV2_26' 'WV2_27' 'WV2_28' 'WV2_34' 'WV2_35' 'WV2_36' 'WV2_37' 'WV2_38' 'WV2_45' 'WV2_46' 'WV2_47' 'WV2_48' 'WV2_56' 'WV2_57' 'WV2_58' 'WV2_67' 'WV2_68' 'WV2_78'};


for scenario=1:28 %number of possibilities

    B1 = band1(:,scenario);
    B2 = band2(:,scenario);
    
    X = log(B1./B2); %CHECK THE LOG or LOG10 HERE!!

    [coeffs,gof] = fit(X,depth,'poly2');
    coeffs = coeffvalues(coeffs);

    %curve for plotting
    domain_X = 0:.01:4;
    domain_X = domain_X';
    curve_forplot = polyval(coeffs,domain_X);
    curve_forplot = [domain_X curve_forplot];
    dlmwrite(strcat(scenario_name{scenario},'_curve.txt'), curve_forplot);
    
    %write a text file to plot original data
    forplot = [X depth];
    dlmwrite(strcat(scenario_name{scenario},'_data.txt'), forplot);
    
    %for all input, calc z
    depth_calc = polyval(coeffs,X);
    
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
    correlation = gof.rsquare;
    
    temp = struct('depth_sonar',depth,'X',X,'a',coeffs(1),'b',coeffs(2),'c',coeffs(3),'Curve',curve_forplot,'depth_calc',depth_calc,'min',minimum,'max',maximum,'mean',mean_calc,'std',std_dev,'q1',q1,'median',median,'q3',q3,'error',error,'error_std',error_std,'RMSE',RMSE,'r2',correlation);
    expr=strcat(scenario_name{scenario},'_stats = temp;'); 
    eval(expr);
    
end

clear band1 band2 scenario_name domain_X curve_forplot depth_calc minimum
clear maximum mean_calc std_dev q1 median q3 error error_std RMSE correlation
clear temp expr coeffs X ans scenario B1 B2 forplot gof

%need to save which ones you want to keep manually
%did for both ln/log and log10/log

