%Calculated resolution of spectra
%Creates space in structures for convolved spectra
%Takes in above output and relative_spectral_responses.mat
%Outputs appropriate convolved spectra

%data doi: 10.5065/D6FQ9TN2

base = 'boat_spectral.';
days = {'july2.';'july3.'};
sats = {'etm_l';'etm_h';'oli';'wv2';'modis';'aster_hi';'aster_normal';'aster_lo'};
%etm - high and low, 8 bit, scaling from Midtre Lovenbreen 
    %as in Pope & Rees, 2014 JAG
%oli - 12 bit, reflectance scaling from metadata
%wv2 - nothing
%modis - 12 bit, and scaling
%aster - high/normal/lo, 8 bit
%parameters set in code below for each sensor (minimum reflectance, maximum
    %reflectance, and radiometric resolution)

%For later calculations, to account for the variable radiometric resolution
%of the measured spectra
boat_spectral.l_rez = zeros(2048,1);
boat_spectral.l_rez(1,1) = boat_spectral.l_(2,1) - boat_spectral.l_(1,1);
for r = 2:2047
    a = boat_spectral.l_(r,1) - boat_spectral.l_(r-1,1);
    b = boat_spectral.l_(r+1,1) - boat_spectral.l_(r,1);
    boat_spectral.l_rez(r,1) = (a+b)/2;
end
boat_spectral.l_rez(2048,1) = boat_spectral.l_(2048,1) - boat_spectral.l_(2047,1);


for day = 1:2
	if day == 1
		for d=1:666
			dbase=strcat(base,days{day},'d',num2str(d),'.');
			for sat=1:8
				satbase = strcat(dbase,sats(sat));
				if sat == 1
					exp=strcat(satbase,' = zeros(3,1);');
					eval(exp{1});
                elseif sat == 2
					exp=strcat(satbase,' = zeros(3,1);');
					eval(exp{1});
                elseif sat == 3
					exp=strcat(satbase,' = zeros(5,1);');
					eval(exp{1});
                elseif sat == 4
					exp=strcat(satbase,' = zeros(8,1);');
					eval(exp{1});
                elseif sat == 5
					exp=strcat(satbase,' = zeros(3,1);');
					eval(exp{1});
                elseif sat == 6
					exp=strcat(satbase,' = zeros(2,1);');
					eval(exp{1});
                elseif sat == 7
					exp=strcat(satbase,' = zeros(2,1);');
					eval(exp{1});
                elseif sat == 8
					exp=strcat(satbase,' = zeros(2,1);');
					eval(exp{1});
                end
			end
		end
	elseif day == 2
		for d=1:1624
			dbase=strcat(base,days{day},'d',num2str(d),'.');
			for sat=1:8
				satbase = strcat(dbase,sats(sat));
				if sat == 1
					exp=strcat(satbase,' = zeros(3,1);');
					eval(exp{1});
                elseif sat == 2
					exp=strcat(satbase,' = zeros(3,1);');
					eval(exp{1});
                elseif sat == 3
					exp=strcat(satbase,' = zeros(5,1);');
					eval(exp{1});
                elseif sat == 4
					exp=strcat(satbase,' = zeros(8,1);');
					eval(exp{1});
                elseif sat == 5
					exp=strcat(satbase,' = zeros(3,1);');
					eval(exp{1});
                elseif sat == 6
					exp=strcat(satbase,' = zeros(2,1);');
					eval(exp{1});
                elseif sat == 7
					exp=strcat(satbase,' = zeros(2,1);');
					eval(exp{1});
                elseif sat == 8
					exp=strcat(satbase,' = zeros(2,1);');
					eval(exp{1});
                end
			end
		end
    end
end

clear d day dbase exp sat satbase a b r

for day = 1:2
	if day == 1
		for d=1:666
			dbase=strcat(base,days{day},'d',num2str(d),'.');
			for sat=1:8
				satbase = strcat(dbase,sats(sat));
				if sat == 1
					exp=strcat('interim=',dbase,'Rrs_ .* ETM_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 0.9241;
                    minimum = -0.0195; %Use approximation from ML, see RSE paper
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                    
                    exp=strcat('interim=',dbase,'Rrs_ .* ETM_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					                    %added for the bit calcs
                    b = interim;
                    maximum = 1.0434;
                    minimum = -0.0222;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* ETM_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					                    %added for the bit calcs
                    b = interim;
                    maximum = 0.9607;
                    minimum = -0.0205;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 2
					exp=strcat('interim=',dbase,'Rrs_ .* ETM_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 0.6028;
                    minimum = -0.0195;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                    
                    exp=strcat('interim=',dbase,'Rrs_ .* ETM_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					                    %added for the bit calcs
                    b = interim;
                    maximum = 0.6814;
                    minimum = -0.0222;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* ETM_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					                    %added for the bit calcs
                    b = interim;
                    maximum = 0.6267;
                    minimum = -0.0205;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                    
                elseif sat == 3
					exp=strcat('interim=',dbase,'Rrs_ .* OLI_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* OLI_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* OLI_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* OLI_4_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_4_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(4,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* OLI_8_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_8_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(5,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 4
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_4_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_4_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(4,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_5_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_5_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(5,1) = interim;');
					eval(exp{1});
                    
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_6_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_6_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(6,1) = interim;');
					eval(exp{1});
                    
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_7_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_7_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(7,1) = interim;');
					eval(exp{1});
                    
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_8_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_8_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(8,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 5
                    exp=strcat('interim=',dbase,'Rrs_ .* MODIS_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*MODIS_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.2090;
                    minimum = 0.0142;
                    Qmax = 4095;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* MODIS_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*MODIS_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.1788;
                    minimum = 0.0428;
                    Qmax = 4095;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* MODIS_4_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*MODIS_4_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.1802;
                    minimum = 0.0225;
                    Qmax = 4095;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 6
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 0.5065;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 0.631306;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 7
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.26625;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.262613;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 8
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.687345;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.682308;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});                    
                    
                end
			end
		end
	elseif day == 2
		for d=1:1624
			dbase=strcat(base,days{day},'d',num2str(d),'.');
			for sat=1:8
				satbase = strcat(dbase,sats(sat));
				if sat == 1
					exp=strcat('interim=',dbase,'Rrs_ .* ETM_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 0.9241;
                    minimum = -0.0195; %Use approximation from ML, see RSE paper
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                    
                    exp=strcat('interim=',dbase,'Rrs_ .* ETM_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					                    %added for the bit calcs
                    b = interim;
                    maximum = 1.0434;
                    minimum = -0.0222;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* ETM_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					                    %added for the bit calcs
                    b = interim;
                    maximum = 0.9607;
                    minimum = -0.0205;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 2
					exp=strcat('interim=',dbase,'Rrs_ .* ETM_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 0.6028;
                    minimum = -0.0195;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                    
                    exp=strcat('interim=',dbase,'Rrs_ .* ETM_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					                    %added for the bit calcs
                    b = interim;
                    maximum = 0.6814;
                    minimum = -0.0222;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* ETM_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ETM_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					                    %added for the bit calcs
                    b = interim;
                    maximum = 0.6267;
                    minimum = -0.0205;
                    Qmax = 255;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                    
                elseif sat == 3
					exp=strcat('interim=',dbase,'Rrs_ .* OLI_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* OLI_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* OLI_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* OLI_4_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_4_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(4,1) = interim;');
					eval(exp{1});
                    
                    					
                    exp=strcat('interim=',dbase,'Rrs_ .* OLI_8_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*OLI_8_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.210700;
                    minimum = -0.099980;
                    Qmax = 4095; %Max DN is actually 65535, but the sensor is 12 bit while data reported as 16 bit
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(5,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 4
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_4_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_4_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(4,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_5_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_5_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(5,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_6_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_6_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(6,1) = interim;');
					eval(exp{1});
                    
                    
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_7_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_7_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(7,1) = interim;');
					eval(exp{1});
                    
                    exp=strcat('interim=',dbase,'Rrs_ .* WV2_8_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*WV2_8_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
					exp=strcat(satbase,'(8,1) = interim;');
					eval(exp{1});
                    
                    
                elseif sat == 5
                    exp=strcat('interim=',dbase,'Rrs_ .* MODIS_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*MODIS_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.2090;
                    minimum = 0.0142;
                    Qmax = 4095;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* MODIS_3_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*MODIS_3_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.1788;
                    minimum = 0.0428;
                    Qmax = 4095;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* MODIS_4_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*MODIS_4_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.1802;
                    minimum = 0.0225;
                    Qmax = 4095;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(3,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 6
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 0.5065;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 0.631306;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 7
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.26625;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.262613;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});
                    
                elseif sat == 8
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_1_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_1_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.687345;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(1,1) = interim;');
					eval(exp{1});
                    
                                        
                    exp=strcat('interim=',dbase,'Rrs_ .* ASTER_2_tedesco;');
                    eval(exp);
                    interim = interim.*boat_spectral.l_rez;
                    list = find(isfinite(interim));
					interim = sum(interim(list)) / sum(boat_spectral.l_rez(list).*ASTER_2_tedesco(list));
                    if interim == 0
                        interim = NaN;
                    end
                    %added for the bit calcs
                    b = interim;
                    maximum = 1.682308;
                    minimum = 0;
                    Qmax = 254;
                    Qmin = 1;
                    if interim > maximum;
                        b = Qmax;
                    elseif interim < minimum;
                        b = Qmin;
                    else
                        b = round((interim - minimum)/(maximum-minimum)*(Qmax-Qmin)+Qmin);
                    end
                    interim = b*(maximum-minimum)/(Qmax-Qmin); %Converts back to reflectances
                    %
                    exp=strcat(satbase,'(2,1) = interim;');
					eval(exp{1});                    
                    
                end
			end
        end
    end
end

clear base d day days dbase exp sat satbase sats list
save for_lake_spectra maximum minimum Qmax Qmin a b r interim