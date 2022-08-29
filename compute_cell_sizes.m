function [elens,nlens]=compute_cell_sizes(vlats,vlons)
% Elens: East Lengths
% Nlens: North Lengths

nz = size(vlats,1)-1;
nm = size(vlats,2)-1;

%%
lats_se = vlats(2:nz+1,1:nm  );
lats_ne = vlats(2:nz+1,2:nm+1);

lons_se = vlons(2:nz+1,1:nm  );
lons_ne = vlons(2:nz+1,2:nm+1);

elens = lldistkm( [lats_se(:),lons_se(:)], [lats_ne(:),lons_ne(:)] );
elens = reshape(elens,[nz,nm]);

%%
lats_nw = vlats(1:nz,2:nm+1);

lons_nw = vlons(1:nz,2:nm+1);

nlens = lldistkm( [lats_nw(:),lons_nw(:)], [lats_ne(:),lons_ne(:)] );
nlens = reshape(nlens,[nz,nm]);

end
