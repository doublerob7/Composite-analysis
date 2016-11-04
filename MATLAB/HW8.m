%% ME 4210 Composites
% HW8 Robert Ressler

% 1. For the given ply orientations and material properties,

plies = [90 -45 -30 30 0];

E1 = 163e9;
E2 = 11.31e9;
G12 = 5.5e9;
nu12 = 3.13;
nu21 = E2*nu12/E1;

% a) Determine Qbar for each ply
Q = [E1/(1-nu12*nu21) nu12*E2/(1-nu12*nu21) 0; nu12*E2/(1-nu12*nu21) E2/(1-nu12*nu21) 0; 0 0 G12];

for i=1:length(plies)
    s = sind(plies(i));
    c = cosd(plies(i));
    T = [c^2 s^2 2*c*s; s^2 c^2 -2*c*s; -c*s c*s c^2-s^2];
    Qbar = (inv(T) * Q * T)/10^9
end

% b) Determine the plies that show no shear coupling (eta = 0)
S = [1/E1 -nu21/E2 0; -nu12/E1 1/E2 0; 0 0 1/G12];

for i=1:length(plies)
    s = sind(plies(i));
    c = cosd(plies(i));
    T = [c^2 s^2 2*c*s; s^2 c^2 -2*c*s; -c*s c*s c^2-s^2];
    Sbar = (inv(T) * Q * T)/10^9;
    eta = [Sbar(1,3)/Sbar(1,1) Sbar(2,3)/Sbar(2,2) Sbar(1,3)/Sbar(3,3) Sbar(2,3)/Sbar(3,3)]';
    if all(eta) == 0
        fprintf('No Shear Coupling present in this lamina\n');
    else
        fprintf('Shear Coupling is present in this lamina\n');
    end
end