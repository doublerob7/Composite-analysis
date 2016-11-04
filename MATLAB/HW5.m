%% ME 4210 - HW5 - Robert Ressler
clc
clear all
format compact

%% 2. Write a MATLAB function that takes the fiber and matrix properties as inputs and plots the composite properties as function of fiber volume fraction.

Ef1 = 224e9;
Ef2 = 19.30e9;
Em = 3.43e9;
Gf12 = 17.45e9;
Gm = 1.21e9;

plot_composite_props( Ef1,Ef2,Em,Gf12,Gm );


%% 3. Determine the longitudinal elastic modulus of interphase, Ei
% Define material properties
E1 = 135.77e9;
Ef1 = 224e9;
Em = 3.43e9;

% fiber volume fraction from HW4
FVF = 0.5690;

% fiber radius from HW4
fiber_r = 3.4631e-6;

% Interphase thickness
t_i = 500e-9;

% RVE includes only fiber and interphase, no matrix. Therefore
MVF = 0;

% Calculate interphase volume fraction IVF
total_RVE_area = pi * (fiber_r + t_i)^2;
IVF = (total_RVE_area - pi * fiber_r^2) / total_RVE_area;

Ei = (E1 - Ef1*FVF - Em*MVF) /IVF