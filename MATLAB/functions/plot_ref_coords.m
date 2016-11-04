function [ E_x,E_y,G_xy,nu_xy,eta_y_xy ] = plot_ref_coords( filename )
%plot_ref_coords Plots E_x, G_xy, E_y, nu_xy and eta_y_xy by reading an excel
%file containing material properties in principal material coordinates

%% Get info and check for file type

% Get some info from the file being read
[status,sheets] = xlsfinfo(filename);

% Check the status variable to make sure the file is an Excel sheet
% If the status isn't the same as the string given...
if strcmp(status,'Microsoft Excel Spreadsheet') == 0
    % ...display an error message...
    disp('Error: File not an Excel sheet.')
    % ...and return nothing
    return
    
% If the string does match, continue the function    
else
    
    % Preallocate memory for theta
    theta = linspace(0,90);
    % Preallocate memory for E_x
    E_x = zeros(1,length(theta));
    % Preallocate memory for E_y
    E_y = zeros(1,length(theta));
    % Preallocate memory for E_y
    G_xy = zeros(1,length(theta));
    % Preallocate memory for nu_xy
    nu_xy = zeros(1,length(theta));
    % Preallocate memory for eta_y_xy
    eta_y_xy = zeros(1,length(theta));
    
    % Start a for loop to read data from each sheet of the xlsx file.
    for read = 1:length(sheets)
        % Read the data from sheets(read) and put it into data
        data = xlsread(filename,read);
        
        % If the length of data (first row) is less than 3
        if length(data) < 3
            % Add values to data up to 3 in the first row
            data(1,3) = 0;
        % End of if block
        end
        
        % Grab the E1 from the 1st column of data
        E_1 = data(1,1);
        % Grab the E2 from the 1st column of data
        E_2 = data(2,1);
        % Grab the Shear modulus from the 2nd column of data
        G_12 = data(1,2);
        % Grab the Poisson Ratio from the 3rd column of data
        nu_12 = data(1,3);
        
        % Calculation loop: compute each property as each discreet theta
        for i = 1:length(theta)
            
            % Calulate the sin and cos of current theta
            s = sind(theta(i));
            c = cosd(theta(i));
            
            % Calculate E_x for current theta
            E_x(i) = ( (c^4/E_1) + (( -2*nu_12/E_1 )+( 1/G_12 ))*s^2*c^2 + (s^4/E_2) )^(-1);
            % Calculate E_y for current theta
            E_y(i) = ( (s^4/E_1) + (( -2*nu_12/E_1 )+( 1/G_12 ))*s^2*c^2 + (c^4/E_2) )^(-1);
            % Calculate G_xy for current theta
            G_xy(i) = ( (s^4 + c^4)/G_12 + 4*( (1/E_1) + (1/E_2) + (2*nu_12)/E_1 + (-1/(2*G_12)) )*s^2*c^2 )^(-1);
            % Calculate nu_xy for current theta
            nu_xy(i) = E_x(i)* ( nu_12/E_1*(s^4+c^4) - (1/E_1 + 1/E_2 - 1/G_12) *s^2*c^2);
            % Calculate S_bar_26 for current theta
            S_bar_26 = (2/E_1)*(1+nu_12-E_1/(2*G_12))*s^3*c - (2/E_2)*(1+nu_12-E_2/(2*G_12))*s*c^3;
            % Calculate S_bar_22 for current theta
            S_bar_22 = s^4/E_1 + (1/G_12 - 2*nu_12/E_1)*s^2*c^2 + c^4/E_2;
            % From S_bars, calculate eta_y_xy for current theta
            eta_y_xy(i) = S_bar_26/S_bar_22;
        % End of i loop    
        end
        
    % End of read loop
    end
    
    % Run supplied plot formatting parameters
    Plot();
    
    % Create a new figure: figure 1
    figure(1)
    % Plot the values of E_x/E_1 over theta
    plot(theta,E_x/E_1)
    % Specify x-axis range from 0 to 90 degrees
    axis([0 90 -inf inf])
    % Set x-axis label
    xlabel('theta (deg)','FontSize',20)
    % Set y-axis label
    ylabel('E_x/E_1','FontSize',20)
    % Set figure title
    title('E_x as a function of theta','FontSize',20)
    % Set the font size of axes numbers
    set(gca,'FontSize',16)
    % Display grid lines
    grid on
    
    % Create figure 2 and set similar parameters as figure 1
    figure(2)
    plot(theta,E_y/E_2)
    axis([0 90 -inf inf])
    xlabel('theta (deg)','FontSize',20)
    ylabel('E_y/E_2','FontSize',20)
    title('E_y as a function of theta','FontSize',20)
    set(gca,'FontSize',16)
    grid on
    
    % Create figure 3 and set similar parameters as figure 1
    figure(3)
    plot(theta,G_xy/G_12)
    axis([0 90 -inf inf])
    xlabel('theta (deg)','FontSize',20)
    ylabel('G_x_y/G_1_2','FontSize',20)
    title('G_x_y as a function of theta','FontSize',20)
    set(gca,'FontSize',16)
    grid on
    
    % Create figure 4 and set similar parameters as figure 1
    figure(4)
    plot(theta,nu_xy/nu_12)
    axis([0 90 -inf inf])
    xlabel('theta (deg)','FontSize',20)
    ylabel('nu_x_y/nu_1_2','FontSize',20)
    title('nu_x_y as a function of theta','FontSize',20)
    set(gca,'FontSize',16)
    grid on
    
    % Create figure 5 and set similar parameters as figure 1
    figure(5)
    plot(theta,eta_y_xy)
    axis([0 90 -inf inf])
    xlabel('theta (deg)','FontSize',20)
    ylabel('eta_y_,_x_y','FontSize',20)
    title('eta_y_,_x_y as a function of theta','FontSize',20)
    set(gca,'FontSize',16)
    grid on
    
    
% End of function
end

