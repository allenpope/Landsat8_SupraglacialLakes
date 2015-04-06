function F = TwoBandDepth(x)
%Called by Jakobshavn_lake_depth_calc.m
%   Solves equation for the two-band physically based method
%   For this method, no need to run individually

global g1 g2 Rw1 Rw2 Rinf1 Rinf2 Ri1 Ri2 Rc1 Rc2

F = ((x*(Ri1-Rc1)+(Rc1-Rinf1))/(Rw1-Rinf1))^g2 - ((x*(Ri2-Rc2)+(Rc2-Rinf2))/(Rw2-Rinf2))^g1;

end

