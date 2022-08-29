function info = make_global_grid_B(res,varargin)

[lats,lons,angs] = make_global_grid(res/2,varargin{:});

angs(isnan(angs)) = 0;
if floor(size(angs,2)/2)*2 == size(angs,2)
    fprintf('Reducing meridional size from %d to %d (even to odd)\n',size(angs,2),size(angs,2)-1);
    lats = lats(:,2:size(angs,2));
    lons = lons(:,2:size(angs,2));
    angs = angs(:,2:size(angs,2));
end

%%
size_i = floor(size(lats,1)/2);
size_j = floor(size(lats,2)/2);
fprintf('Size of the grid: %d by %d\n',size_i,size_j);

%%
info = struct(...
    'tlats',0,  'tlons', 0, ...
    'ulats',0,  'ulons', 0, ...
    'htn', 0,   'hte',   0, ...
    'hus', 0,   'huw',   0, ...
    'angles',0 );

%%
info.tlats = lats(2:2:size(lats,1),2:2:size(lats,2));
info.tlons = lons(2:2:size(lats,1),2:2:size(lats,2));

info.ulats = lats(3:2:size(lats,1),3:2:size(lats,2));
info.ulons = lons(3:2:size(lats,1),3:2:size(lats,2));

info.angles = angs(2:2:size(lats,1),2:2:size(lats,2));

%%
[info.hte,info.htn] = compute_cell_sizes( ...
    lats(1:2:size(lats,1),1:2:size(lats,2)), ...
    lons(1:2:size(lats,1),1:2:size(lats,2)) );
%info.htn = htn(:,2:size(htn,2));
%info.hte = hte(2:size(hte,1),:);
%clear htn; clear hte;

%%
if 90.0 - max(max(info.tlats(:,size_j))) < 1
    tripole = 1;
    fprintf('Tripolar grid\n');
else 
    tripole = 0;
    fprintf('Dipolar grid\n');
end
if tripole == 1
    tlats_ext = [ info.tlats, zeros(size_i,1) ];
    tlons_ext = [ info.tlons, zeros(size_i,1) ];
    for i = 1 : size_i/2
        tlats_ext(i,         size_j+1) = tlats_ext(size_i+1-i,size_j);
        tlats_ext(size_i+1-i,size_j+1) = tlats_ext(i,         size_j);
        tlons_ext(i,         size_j+1) = tlons_ext(size_i+1-i,size_j);
        tlons_ext(size_i+1-i,size_j+1) = tlons_ext(i,         size_j);
    end
else
    tlats_ext = [ info.tlats, info.tlats(:,size_j)*2-info.tlats(:,size_j-1) ];
    tlons_ext = [ info.tlons, info.tlons(:,size_j)*2-info.tlons(:,size_j-1) ];
end
tlats_ext = [ tlats_ext; tlats_ext(1,:) ];
tlons_ext = [ tlons_ext; tlons_ext(1,:) ];

[info.huw,info.hus] = compute_cell_sizes( tlats_ext, tlons_ext );

%%

end