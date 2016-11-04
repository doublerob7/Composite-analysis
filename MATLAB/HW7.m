%% ME 4210 - HW5 - Robert Ressler

clear all
clc
format compact

%% 2. Determine whether the following stress state causes failure based on Tsai-Hill, Tsai-Wu (plane-stress), Hashin (plane-stress)

theta = 10;

s = sind(theta);
c = cosd(theta);

T = [ c^2 s^2   2*s*c ;...
      s^2 c^2  -2*s*c ;...
     -c*s c*s c^2-s^2 ];

slp = 1000;
sln = 500;
stp = 45;
stn = 145;
slt = 57.2;
stt = 32.4;

E1 = 163e3;
E2 = 11.3e3;
G12 = 5.5e3;
nu12 = 3.13;

stress_xy = [75 -150 -10]';

stress_12 = T * stress_xy;

%% Tsai-Hill criteria

if stress_12(1) > 0 && stress_12(2) > 0
    tsai_hill = (stress_12(1)^2 / slp^2) - ( stress_12(1)*stress_12(2) / slp^2) + (stress_12(2)^2 / stp^2) + (stress_12(3)^2 / slt^2);

elseif stress_12(1) < 0 && stress_12(2) > 0
    tsai_hill = (stress_12(1)^2 / sln^2) - ( stress_12(1)*stress_12(2) / sln^2) + (stress_12(2)^2 / stp^2) + (stress_12(3)^2 / slt^2);

elseif stress_12(1) > 0 && stress_12(2) < 0
    tsai_hill = (stress_12(1)^2 / slp^2) - ( stress_12(1)*stress_12(2) / slp^2) + (stress_12(2)^2 / stn^2) + (stress_12(3)^2 / slt^2);

elseif stress_12(1) < 0 && stress_12(2) < 0
    tsai_hill = (stress_12(1)^2 / sln^2) - ( stress_12(1)*stress_12(2) / sln^2) + (stress_12(2)^2 / stn^2) + (stress_12(3)^2 / slt^2);
end

% Check the value of tsai_hill against failure (> 1)
if tsai_hill > 1
    % Print a message and the relevant limits
    fprintf('  Failure: tsai_hill = %f\n', tsai_hill)
    show = [ [ -sln; -stn; -slt ] stress_12 [ slp;  stp; slt ] ];
    disp(show)
end

%% Tsai-Wu criteria

F1 = 1/slp + 1/sln;
F11 = -1/(slp*sln);
F2 = 1/stp + 1/stn;
F22 = -1/(stp*stn);
F66 = 1/slt^2;

tsai_wu = F1*stress_12(1) + F2 * stress_12(2) + F11*stress_12(1)^2 + F22*stress_12(2)^2 + F66*stress_12(3)^2;

% Check the value of tsai_hill against failure (> 1)
if tsai_wu > 1
    % Print a message and the relevant limits
    fprintf('  Failure: tsai_wu = %f\n    Stress State:\n', tsai_wu)
    show = [ [ -sln; -stn; -slt ] stress_12 [ slp;  stp; slt ] ];
    disp(show)
else
    fprintf('  Within Tsai-Wu Failure Envelope\n')
end

%% Hashin criteria

if stress_12(1) > 0
    hash_fiber = stress_12(1)/slp;
else
    hash_fiber = stress_12(1)/-sln;
end

if stress_12(2) > 0
    hash_matrix = (stress_12(2)/slp)^2 + (stress_12(3)/slt)^2;
else
    hash_matrix = (stress_12(2)/(2*stt))^2 + (stress_12(2)/stp)*((stn/(2*stt))^2-1) + (stress_12(3)/slt)^2;
end

% Check the value of tsai_wu against failure for fiber and matrix
if hash_fiber > 1
    if stress_12(1) > 0
        % Print a message and the relevant limits
        fprintf('  Tensile Fiber Failure\n')
        show = [ [ -sln; -stn; -slt ] stress_12 [ slp;  stp; slt ] ];
        disp(show)
    else
        % Print a message and the relevant limits
        fprintf('  Compressive Fiber Failure\n')
        show = [ [ -sln; -stn; -slt ] stress_12 [ slp;  stp; slt ] ];
        disp(show)
    end
elseif hash_matrix > 1
    if stress_12(2) > 0
        % Print a message and the relevant limits
        fprintf('  Tensile Matrix Failure\n')
        show = [ [ -sln; -stn; -slt ] stress_12 [ slp;  stp; slt ] ];
        disp(show)
    else
        % Print a message and the relevant limits
        fprintf('  Compressive Matrix Failure\n')
        show = [ [ -sln; -stn; -slt ] stress_12 [ slp;  stp; slt ] ];
        disp(show)
    end
else
    fprintf('  Within Hashin Failure Envelope\n')
end


nu21 = nu12 * E2 / E1;

strain_12 = [ E1^-1 -nu21/E2 0; -nu12/E1 E2^-1 0; 0 0 G12^-1 ] * stress_12;

elp = slp/E1;
eln = sln/E1;
etp = stp/E2;
etn = stn/E2;
elt = slt/G12;

%% 3. Functional equivalent to 2.

lamina_failure('Inputs/HW7.xlsx');
