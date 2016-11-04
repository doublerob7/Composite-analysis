%% ME 4210 Composites HW10 Robert Ressler

clear all
clc
format shortg

% Properties

El = [138e9 9e9 0]; % Gpa = Pa e9
G = [6.9e9 0 0]; % Gpa = Pa e9
v = [.32 0 0];

stack = [30 -60 -30 60]; % degrees

thickness = 1e-3; % m

N = [ 2.5e6 1.5e6 1e6 ]; % kN/mm = N/m e6
M = [ 20e3 15e3 10e3 ]; % Nm/mm = Nm/m e3

[ A,B,D ] = laminaStiffness(El,v,G,stack,thickness);
E = [A B; B D];
IPR = [N M]';

[E_inv,Eps_mid,Curv_mid,Eps_layers,Sig_layers ] = lamina_analysis (E,IPR,E,G,v,thickness,stack)