function [E_inv,Eps_mid,Curv_mid,Eps_layers,Sig_layers ] = lamina_analysis (El,IPR,E,G,v,t,stack)
% lamina_analysis takes lamina properties and stacking sequence and returns
% the inverted stiffness matrix, the midplane strain and curvatures
% and the stress and strain in the principle material direction for each
% layer.

    A = El(1:3,1:3);
    B = El(4:6,1:3);
    D = El(4:6,4:6);
    
    A_star = inv(A);
    B_star = -A_star * B;
    C_star = B * A_star;
    D_star = D - B*A_star*B;

    A_prime = A_star - B_star*inv(D_star)*C_star;
    B_prime = B_star * inv(D_star);
    C_prime = inv(D_star)*C_star;
    D_prime = inv(D_star);

    % Assemble inverse stiffness matrix
    E_inv = [A_prime B_prime; C_prime D_prime];

    % Mid-plane strains and curvature
    Eps_curv_mid = E_inv * IPR;
    Eps_mid = Eps_curv_mid(1:3);
    Curv_mid = Eps_curv_mid(4:6);
    
    % Preallocate
    Eps_layers = zeros(3,3,length(stack));
    Sig_layers = zeros(3,3,length(stack));
    
    % Lamina stresses and strains
    for i = 1:length(stack)

        % Sin, Cos for the layer
        s = sind(stack(i));
        c = cosd(stack(i));

        % Transformation matrix to reference coords
        T = [c^2 s^2    2*c*s; ...
             s^2 c^2   -2*c*s; ...
            -c*s c*s  c^2-s^2];
        T_E = [c^2     s^2     c*s; ...
               s^2     c^2    -c*s; ...
              -2*c*s 2*c*s c^2-s^2];

        % Q_bar, reduced stiffness matrix
        Q = [ E(1)/(1-v(1)*v(2)) v(1)*E(2)/(1-v(1)*v(2)) 0; ...
            v(1)*E(2)/(1-v(1)*v(2)) E(2)/(1-v(1)*v(2)) 0; ...
            0 0 G(1)];
        Qbar = inv(T) * Q * T_E;
        
        % Lamina layer depth
        z_k = t * (i-length(stack)/2);
        z_k1 = z_k - t;
        z = [z_k (z_k+z_k1)/2 z_k1];
        
        for j = 1:length(z)
            % Strain in the layer
            Eps_layers(:,j,i) = (Eps_mid + z(j)*Curv_mid)';

            % Stress in the layer
            Sig_layers(:,j,i) = Qbar * Eps_layers(:,j,i);
        end

    end
end