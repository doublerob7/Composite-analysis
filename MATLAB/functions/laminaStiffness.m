function [ A,B,D ] = laminaStiffness( E,v,G, stack, thickness )
%laminaStiffness_ressler takes engineering constants, E, nu, G, a stack
%sequence and a lamina thinkness and returns the stiffness submatrices A, B
%and D.

    % Preallocation
    A = zeros(3);
    B = zeros(3);
    D = zeros(3);
    eta = zeros(length(stack),4);
    z_k = 0;
    v(2) = v(1)/E(1) * E(2);

    % Loop
    for k = 1:length(stack);

        % Depth of the current ply
        z_k = thickness * (k-length(stack)/2);
        z_k1 = z_k - thickness;

        % Angle of current ply
        s = sind(stack(k));
        c = cosd(stack(k));

        % Transformation matrix to reference coords
        T = [c^2 s^2    2*c*s; ...
             s^2 c^2   -2*c*s; ...
            -c*s c*s  c^2-s^2];
        T_E = [c^2     s^2     c*s; ...
               s^2     c^2    -c*s; ...
              -2*c*s 2*c*s c^2-s^2];

        % Q_bar matrix
        Q = [ E(1)/(1-v(1)*v(2)) v(1)*E(2)/(1-v(1)*v(2)) 0; ...
            v(1)*E(2)/(1-v(1)*v(2)) E(2)/(1-v(1)*v(2)) 0; ...
            0 0 G(1)];
        Qbar = inv(T) * Q * T_E;

        % A matrix
        A = A + Qbar * (z_k - z_k1);

        % B matrix
        B = B + (1/2 * Qbar * (z_k^2 - z_k1^2));

        % D matrix
        D = D + (1/3 * Qbar * (z_k^3 - z_k1^3));

    end

    % Coupling
    if abs(A(1,3)) > 1e-6 || abs(A(2,3)) > 1e-6
        fprintf('Stretching-Shear coupling present.\n');
    end
    if abs(B(1,1)) > 1e-6 || abs(B(1,2)) > 1e-6 || abs(B(2,2)) > 1e-6
        fprintf('Stretching-Bending coupling present.\n');
    end
    if abs(B(1,3)) > 1e-6 || abs(B(2,3)) > 1e-6
        fprintf('Stretching-Twisting coupling present.\n');
    end
    if abs(B(3,3)) > 1e-6
        fprintf('Shear-Twisting coupling present.\n');
    end
    if abs(D(1,3)) > 1e-6 || abs(D(2,3)) > 1e-6
        fprintf('Bending-Twisting coupling present.\n');
    end

end

