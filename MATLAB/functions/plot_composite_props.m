function [ ] = plot_composite_props( Ef1,Ef2,Em,Gf12,Gm )
%composite_props_ressler Takes fiber and matrix properties and plots the
%composite properties as a function of fiber volume fraction. 

% Define fiber volume fraction array
FVF = linspace(0,1);

% Calculate Matrix volume fraction
MVF = 1 - FVF;

% Plot E1
E1 = Ef1*FVF + Em*MVF;

% Plot E1
subplot(3,1,1)
plot(FVF,E1)
title('E1')
xlabel('Fiber volume fraction','FontSize',14)
ylabel('Elastic Modulus in 1-direction [Gpa]','FontSize',10)

% Plot E2
E2 = (FVF/Ef2 + MVF/Em).^-1;

subplot(3,1,2)
plot(FVF,E2)
title('E2')
xlabel('Fiber volume fraction','FontSize',14)
ylabel('Elastic Modulus in 2-direction [Gpa]','FontSize',10)


% Plot G12
G12 = (FVF/Gf12 + MVF/Gm).^-1;

subplot(3,1,3)
plot(FVF,G12)
title('G12')
xlabel('Fiber volume fraction','FontSize',14)
ylabel('Shear Modulus in 1-2-direction [Gpa]','FontSize',10)


end

