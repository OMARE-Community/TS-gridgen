function [ lens_zonal, lens_merid ] = compute_cell_edge_sizes( lats_V, lons_V, varargin )

nz = size(lats_V,1)-1;
nm = size(lats_V,2)-1;

Z = sind(lats_V);
X = cosd(lats_V) .* cosd(lons_V);
Y = cosd(lats_V) .* sind(lons_V);

%% Zonal

dX = X(1:nz,2:nm+1) - X(1:nz,1:nm);
dY = Y(1:nz,2:nm+1) - Y(1:nz,1:nm);
dZ = Z(1:nz,2:nm+1) - Z(1:nz,1:nm);

lens_zonal = 6371.0 * ( dX.^2 + dY.^2 + dZ.^2 ).^(0.5);


%% Meridional

dX = X(2:nz+1,1:nm) - X(1:nz,1:nm);
dY = Y(2:nz+1,1:nm) - Y(1:nz,1:nm);
dZ = Z(2:nz+1,1:nm) - Z(1:nz,1:nm);

lens_merid = 6371.0 * ( dX.^2 + dY.^2 + dZ.^2 ).^(0.5);


if numel(varargin) > 0
    M = varargin{1}.M;
    Z = varargin{1}.Z;
    
    lens_merid = lens_merid .* (M == 0);
    lens_zonal = lens_zonal .* (Z == 0);
end

end