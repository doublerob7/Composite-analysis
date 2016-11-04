%% ME 4210 - HW5 - Robert Ressler
clc
clear all
format compact

%% 2. Evaluate whether the following stress state causes failure based on Max Stress and Max Strain criteria
theta = 60;

s = sind(theta);
c = cosd(theta);

T = [ c^2 s^2   2*s*c ;...
      s^2 c^2  -2*s*c ;...
     -c*s c*s c^2-s^2 ];

Slp = 1000;
Sln = 500;
Stp = 45;
Stn = 145;
Slt = 57.2;

E1 = 163e3;
E2 = 11.3e3;
G12 = 5.5e3;
nu12 = 3.13;

stress_xy = [75 -150 -10]';

stress_12 = T * stress_xy;

show = [ [ -Sln; -Stn; -Slt ] stress_12 [ Slp;  Stp; Slt ] ];
disp(show)

if stress_12(1) < -Sln 
    fprintf('Fails in 1-direction compression\n')
elseif stress_12(1) > Slp
    fprintf('Fails in 1-direction tension\n')
end
if stress_12(2) < -Stn
    fprintf('Fails in 2-direction compression\n')
elseif stress_12(2) > Stp
    fprintf('Fails in 2-direction tension\n')
end
if abs(stress_12(3)) > Slt
    fprintf('Fails in shear\n')
else
    %fprintf('Within failure envelope\n')
end

nu21 = nu12 * E2 / E1;

strain_12 = [ E1^-1 -nu21/E2 0; -nu12/E1 E2^-1 0; 0 0 G12^-1 ] * stress_12;

elp = Slp/E1;
eln = Sln/E1;
etp = Stp/E2;
etn = Stn/E2;
elt = Slt/G12;

show2 = [ [ -eln; -etn; -elt ] strain_12 [ elp;  etp; elt ] ];
disp(show2)

if strain_12(1) < -eln 
    fprintf('Fails in 1-direction compression\n')
elseif strain_12(1) > elp
    fprintf('Fails in 1-direction tension\n')
end
if strain_12(2) < -etn
    fprintf('Fails in 2-direction compression\n')
elseif strain_12(2) > etp
    fprintf('Fails in 2-direction tension\n')
end
if abs(strain_12(3)) > elt
    fprintf('Fails in shear\n')
else
    %fprintf('Within failure envelope\n')
end

%% 3. Functional Equivalent to 2.

lamina_failure('Inputs/HW6.xlsx');