function info = make_global_grid_C(res)

[lats,lons,angs] = make_global_grid(res/2);
info = struct(...
    'tlats',{},  'tlons', {}, ...
    'ulats',{},  'ulons', {}, ...
    'vlats',{},  'vlons', {}, ...
    'flats',{},  'flons', {}, ...
    'angles',{} );

info.tlats = lats(2:2:size(lats,1),2:2:size(lats,2));
info.tlons = lons(2:2:size(lats,1),2:2:size(lats,2));

info.ulats = lats(3:2:size(lats,1),2:2:size(lats,2));
info.ulons = lons(3:2:size(lats,1),2:2:size(lats,2));

info.vlats = lats(2:2:size(lats,1),3:2:size(lats,2));
info.vlons = lons(2:2:size(lats,1),3:2:size(lats,2));

info.flats = lats(3:2:size(lats,1),3:2:size(lats,2));
info.flons = lons(3:2:size(lats,1),3:2:size(lats,2));

info.angles = angs(2:2:size(lats,1),2:2:size(lats,2));

end