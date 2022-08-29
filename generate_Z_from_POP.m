function [z,kmt]=generate_Z_from_POP(lats,lons)

DP_OPTION = 1;  % 60-lyr POP default from GX1V6
Z_OPTION = 1;   % Using bathymetry from TX0.1V2

%%
dp = -1;
if DP_OPTION == 1
    dp = load('~/MATLAB/Gridgen/CESM/gx1v6_vert_grid');
    dp = dp(:,2);
end

%%
if Z_OPTION == 1
    info = load('~/Dropbox/z.Work/CESM/OCN_grids/TS_Series/0.Data-MATLAB/topo.mat');
    info = info.topo_t01;
    
    T = scatteredInterpolant(...
        info.lons(:),info.lats(:),info.Z(:), ...
        'linear','nearest');
    z = T(lons(:),lats(:));
    z = reshape(z,size(lons,1),size(lons,2));
else
    z = generate_Z(lats,lons);
end

%%
kmt = zeros(size(lons));
for i = 1 : numel(dp)
    kmt(z<-dp(i)) = i;
end

%%
end