%Regresses depths and convolved spectra to emulate band-ratio
    %satellite lake depth retrievals for a range of sensors. A wider
    %investigation of WorldView-2 bands (see Moussavi et al., 2015 - RSE)
    %is conducted with method2_wv2_revised.m. All data are stored in
    %two_band_regression_stats.mat
%data doi: 10.5065/D6FQ9TN2


band1 = [etm2_l etm2_h etm1_l etm1_h oli2 oli3 oli1 oli1 oli1 oli1 aster1_lo aster1_hi aster1_normal modis4 wv21 wv23 wv23]; %lower band wavelength
band2 = [etm3_l etm3_h etm3_l etm3_h oli4 oli4 oli2 oli3 oli4 oli8 aster2_lo aster2_hi aster2_normal modis1 wv23 wv26 wv24]; %higher band wavelength
scenario_name = {'ETM_GR_low' 'ETM_GR_high' 'ETM_BR_low' 'ETM_BR_high' 'OLI_BR' 'OLI_GR' 'OLI_CB' 'OLI_CG' 'OLI_CR' 'OLI_CPan' 'ASTER_GR_lo' 'ASTER_GR_hi' 'ASTER_GR_normal' 'MODIS_GR' 'WV2_CG' 'WV2_GRedge' 'WV2_GY' };


for scenario=1:16 %number of possibilities

    B1 = band1(:,scenario);
    B2 = band2(:,scenario);
    
    X = log(B1./B2);

    coeffs = polyfit(X,depth,2);

    %curve for plotting
    domain_X = 0:.01:2;
    domain_X = domain_X';
    curve_forplot = coeffs(3) + coeffs(2)*domain_X + coeffs(1)*domain_X.*domain_X;
    curve_forplot = [domain_X curve_forplot];
    dlmwrite(strcat(scenario_name{scenario},'_curve.txt'), curve_forplot);
    
    %write a text file to plot original data
    forplot = [X depth];
    dlmwrite(strcat(scenario_name{scenario},'_data.txt'), forplot);
    
    %for all input, calc z
    depth_calc = coeffs(3) + coeffs(2)*(X) + coeffs(1)*(X).*(X);
    
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
    
    temp = struct('depth_sonar',depth,'X',X,'a',coeffs(3),'b',coeffs(2),'c',coeffs(1),'Curve',curve_forplot,'depth_calc',depth_calc,'min',minimum,'max',maximum,'mean',mean_calc,'std',std_dev,'q1',q1,'median',median,'q3',q3,'error',error,'error_std',error_std,'RMSE',RMSE,'r',correlation);
    expr=strcat(scenario_name{scenario},'_stats = temp;'); 
    eval(expr);
    
end

clear band1 band2 scenario_name domain_X curve_forplot depth_calc minimum
clear maximum mean_calc std_dev q1 median q3 error error_std RMSE correlation
clear temp expr coeffs X ans scenario B1 B2 forplot

%need to save stats manually