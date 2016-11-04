%% ME 4210 Composites HW9 - Robert Ressler

clc
clear all
format shortg

% 2.
E = [163e9 11.31e9 11.31e9];
nu = [3.13 0 0];
G = [5.5e9 0 0];
t = 1e-3;

% a) [ +- 30 / -+ 45 ]s 
stack = [ 30 -30 -45 45 45 -45 -30 30 ];
fprintf('\nStack:')
disp(stack);
[A,B,D] = laminaStiffness(E,nu,G,stack,t);
disp([A B; B D]);

% b) 
stack = [ 0 90 0 90 ];
fprintf('\nStack:')
disp(stack);
[A,B,D] = laminaStiffness(E,nu,G,stack,t);
disp([A B; B D]);

% c)
stack = [ 30 0 60 -30 -60];
fprintf('\nStack:')
disp(stack);
[A,B,D] = laminaStiffness(E,nu,G,stack,t);
disp([A B; B D]);


% d)
stack = [ 0 90 0 90 90 0 90 0 ];
fprintf('\nStack:')
disp(stack);
[A,B,D] = laminaStiffness(E,nu,G,stack,t);
disp([A B; B D]);
