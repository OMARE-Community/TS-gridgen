function [lats,lons,angs]=make_north_hemis_grid(res,varargin)

PLOT = 0;
if numel(varargin) > 0
    PLOT = varargin{1};
end

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
clat = 0;
csteps = zeros(0,1);
while clat < ILAT
    cstep = res / secd(clat);
    clat = clat + cstep;
    csteps = [csteps; cstep];
end

llats = zeros(numel(csteps),1);
for i = 1 : numel(csteps)-1
    llats(i+1) = llats(i+1) + sum(csteps(1:i));
end

fprintf('Turning latitude: %.3fN at %d\n',clat,i);

[nlons,nlats,nangs]=plot_poles(LON,LATS,clat,res);

%%
lons = zeros(size(llats,1)+size(nlons,1),size(nlons,2));
lats = zeros(size(llats,1)+size(nlons,1),size(nlons,2));
angs = zeros(size(llats,1)+size(nlons,1),size(nlons,2));

for i = 1 : size(llats,1)
    lats(i,:) = llats(i);
end
for j = 1 : size(nlons,2)
    lons(:,j) = nlons(size(nlons,1),j);
end

lats(size(llats,1)+1:size(lats,1),:) = nlats(size(nlats,1):-1:1,:);
lons(size(llats,1)+1:size(lats,1),:) = nlons(size(nlats,1):-1:1,:);

angs(1:size(llats,1),:) = 0;
angs(size(llats,1)+1:size(lats,1),:) = nangs(size(nlats,1):-1:1,:);

%%
if PLOT == 1
    plot_grid(lats,lons,'region','NP');
    plot_merid_stepping(lats,6);
end

end
