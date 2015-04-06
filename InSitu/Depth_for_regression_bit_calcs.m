%Extracts depth from the boat_spectral structure

%data doi: 10.5065/D6FQ9TN2

%cd to appropriate directory
%load('boat_spectral_data.mat');

base = 'boat_spectral.';
days = {'july2.';'july3.'}; %same days used in Tedesco & Steiner 2012

depth = zeros(2290,1);
rdepth=0;

for day = 1:2
	if day == 1
		for d=1:666
			dbase=strcat(base,days{day},'d',num2str(d),'.');
			exp=strcat('a = ',dbase,'depth;');
            eval(exp);
            rdepth = rdepth+1;
            depth(rdepth) = a;
		end
	elseif day == 2
		for d=1:1624
			dbase=strcat(base,days{day},'d',num2str(d),'.');
			exp=strcat('a = ',dbase,'depth;');
            eval(exp);
            rdepth = rdepth+1;
            depth(rdepth) = a;
		end
	end
end

clear base d day days dbase exp rdepth a