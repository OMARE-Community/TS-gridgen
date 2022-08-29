function [LON, LATS, ILAT, SLAT] = make_config

LON = -104;  LATS = [ 63, 59.5 ];  ILAT = 10; 
    % Generates: 800x300 for 0.45-Deg w/ mean val towards NP of 1/2.5
    % Also satisfies <5km merid. resolution in the Arctic (0.075-Deg)

%LON = -110;  LATS = [ 62, 58 ];  ILAT = 10;  % Generates: 800x255
%LON = -110;  LATS = [ 64, 59 ];  ILAT = 10;  % Generates: 800x255

%%
SLAT = -78.56;

end