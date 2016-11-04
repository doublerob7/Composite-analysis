function [ C,S ] = generateCS( filename )
%generateCS Generates siffness and compliance matrices by reading an excel
%file containing material properties

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
    
    % Preallocate memory for S
    S = zeros(6,6,3);
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
        
        % Grab the Elastic modulus from the 1st column of data
        E = data(:,1);
        % If the length of E (first col) is less than 3
        if length(E) < 3
            % Add values to the end of E, up to 3, in the first col
            E(3) = 0;
        % End of if block
        end
        % Grab the Shear modulus from the 2nd column of data
        G = data(:,2);
        % If the length of G (first col) is less than 3
        if length(G) < 3
            % Add values to the end of G up to 3 in the first col
            G(3) = 0;
        % End of if block
        end
        % Grab the Poisson Ratio from the 3rd column of data
        nu = data(:,3);
        % If the length of nu (first col) is less than 3
        if length(nu) < 3
            % Add values to the end of nu up to 3 in the first col
            nu(3) = 0;
        % End of if block
        end
        
        %% Fix missing Data
        % This section checks for zeros and NaN's in the data read and
        % fills in those values.
        
        %Start for loop for each row
        for row = 1:3
            % If E is 0 or NaN
            if E(row) == 0 || isnan(E(row)) == 1
                % If G or nu is also 0, then a plane of isotropy is
                % identified and...
                if G(row) == 0 || nu(row) == 0
                    % ...E becomes the same as the axis before it
                    E(row) = E(row-1);
                % If G and nu have values...
                elseif G(row) ~= 0 && nu(row) ~= 0
                    % ...then calculate the corresponding value of E
                    E(row) = G(row) * 2*(1+nu(row));
                % End of if block
                end
            % End of if block
            end
            % If G is 0 or NaN
            if G(row) == 0 || isnan(G(row)) == 1
                % If E or nu is also 0, then a plane of isotropy is
                % identified and...
                if nu(row) == 0 || E(row) == 0
                    % ...G becomes the same as the axis before it
                    G(row) = G(row-1);
                % If E and nu have values...
                elseif E(row) ~= 0 && nu(row) ~= 0
                    % ...then calculate the corresponding value of G
                    G(row) = E(row) / (2*(1+nu(row)));
                % End of if block
                end
            % End of if block
            end
            % If nu is 0 or NaN
            if nu(row) == 0 || isnan(nu(row)) == 1
                % If E or G is also 0, then a plane of isotropy is
                % identified and...
                if E(row) == 0 || G(row) == 0
                    % ...nu becomes the same as the axis before it
                    nu(row) = nu(row-1);
                % If E and G have values...
                elseif E(row) ~= 0 && G(row) ~= 0
                    % ...then calculate the corresponding value of nu
                    nu(row) = E(row)/(2*G(row)) -1;
                % End of if block
                end
            % End of if block
            end
        % End of for loop
        end
        
        %% Generate Stiffness/Compliance Matrices
        % Calculate Sij matrix
        S(:,:,read) = [ 1/E(1) -nu(1)/E(2) -nu(3)/E(3) 0 0 0 ;...
             -nu(1)/E(1) 1/E(2) -nu(2)/E(3)  0 0 0;...
             -nu(3)/E(1) -nu(2)/E(2) 1/E(3)  0 0 0;...
             0 0 0 1/G(2) 0 0 ;...
             0 0 0 0 1/G(3) 0 ;...
             0 0 0 0 0 1/G(1) ];
        
        % Determine Stiffness matrix from Compliance
        C(:,:,read) = eye(6)/S(:,:,read);
        
    % End of read loop
    end

% End of function
end

