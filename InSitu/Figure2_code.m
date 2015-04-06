%Uses the data outputted above to plot the components of Figure 2 in Pope et al., 2015
%data doi: 10.5065/D6FQ9TN2

%For Figure 2a
%cd _________/LakeSpectra %to appropriate directory
load('single_band_regression_stats.mat')
scatter(oli1_stats.depth_sonar(:),oli1_stats.R)
hold on
scatter(oli2_stats.depth_sonar(:),oli2_stats.R)
scatter(oli3_stats.depth_sonar(:),oli3_stats.R)
scatter(oli4_stats.depth_sonar(:),oli4_stats.R)
scatter(oli8_stats.depth_sonar(:),oli8_stats.R)
plot(oli1_stats.Curve(1,:),oli1_stats.Curve(2,:))
plot(oli2_stats.Curve(1,:),oli2_stats.Curve(2,:))
plot(oli3_stats.Curve(1,:),oli3_stats.Curve(2,:))
plot(oli4_stats.Curve(1,:),oli4_stats.Curve(2,:))
plot(oli8_stats.Curve(1,:),oli8_stats.Curve(2,:))
hold off

%For Figure 2b
%cd _________/LakeSpectra %to appropriate directory
load('single_band_regression_stats.mat')
scatter(etm1_h_stats.depth_sonar(:),etm1_h_stats.R)
hold on
scatter(etm2_h_stats.depth_sonar(:),etm2_h_stats.R)
scatter(etm3_h_stats.depth_sonar(:),etm3_h_stats.R)
plot(etm1_h_stats.Curve(1,:),etm1_h_stats.Curve(2,:))
plot(etm2_h_stats.Curve(1,:),etm2_h_stats.Curve(2,:))
plot(etm3_h_stats.Curve(1,:),etm3_h_stats.Curve(2,:))
hold off

%For Figure 2c
%cd _________/LakeSpectra %to appropriate directory
load('single_band_regression_stats.mat')
scatter(etm1_l_stats.depth_sonar(:),etm1_l_stats.R)
hold on
scatter(etm2_l_stats.depth_sonar(:),etm2_l_stats.R)
scatter(etm3_l_stats.depth_sonar(:),etm3_l_stats.R)
plot(etm1_l_stats.Curve(1,:),etm1_l_stats.Curve(2,:))
plot(etm2_l_stats.Curve(1,:),etm2_l_stats.Curve(2,:))
plot(etm3_l_stats.Curve(1,:),etm3_l_stats.Curve(2,:))
hold off

%For Figure 2d
%cd _________/LakeSpectra %to appropriate directory
load('two_band_regression_stats.mat')
scatter(OLI_CPan_stats.X,OLI_CPan_stats.depth_sonar)
hold on
plot(OLI_CPan_stats.Curve(21:81,1),OLI_CPan_stats.Curve(21:81,2))
hold off

%For Figure 2e
%cd _________/LakeSpectra %to appropriate directory
load('two_band_regression_stats.mat')
scatter(OLI_CG_stats.X,OLI_CG_stats.depth_sonar)
hold on
plot(OLI_CG_stats.Curve(1:61,1),OLI_CG_stats.Curve(1:61,2))
hold off