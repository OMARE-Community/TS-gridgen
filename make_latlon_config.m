function [LON,LATS,ILAT,POLE_LAT] = make_latlon_config

%%
%LON = -110;  LATS = [ 55.8, 50 ];  ILAT = 10;  
    % Generates: 800x240 for 0.45-Deg w/ mean val for POLE
%LON = -110;  LATS = [ 53, 53 ];  ILAT = 10;  

LON = -104;  LATS = [ 63, 59.5 ];  ILAT = 10; 
    % Generates: 800x300 for 0.45-Deg w/ mean val towards NP of 1/2.5
    % Also satisfies <5km merid. resolution in the Arctic (0.075-Deg)

%LON = -110;  LATS = [ 62, 58 ];  ILAT = 10;  % Generates: 800x255
%LON = -110;  LATS = [ 64, 59 ];  ILAT = 10;  % Generates: 800x255

%%

POLE_LAT = mean(LATS);
%POLE_LAT = mean([POLE_LAT,90]);
POLE_LAT = (90-POLE_LAT)/2.5+POLE_LAT;

end