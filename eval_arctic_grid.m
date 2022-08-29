function info = eval_arctic_grid(res,zinfo,varargin)

PLOT = 0;
thres = 5.0;
if numel(varargin) > 0
    thres = varargin{1};
end

%%
[lats,lons,angs] = make_global_grid(res/2);

[MT,NT,MU,NU,tlats,tlons,ulatsE,ulonsE] = split_TU_Bgrid(lats,lons);

[htn,hte] = compute_cell_edge_sizes(ulatsE,ulonsE);

ulats = ulatsE(2:MT+1,2:NT+1);
ulons = ulonsE(2:MT+1,2:NT+1);

tlatsE = [tlats; tlats(1,:)];
tlonsE = [tlons; tlons(1,:)];
[hus,huw] = compute_cell_edge_sizes(tlatsE,tlonsE);
hus = [ hus, hus(:,NT-1)*2-hus(:,NT-2) ];
huw = [ huw, huw(:,NT-1)*2-huw(:,NT-2) ];

%angles = compute_angles(ulats,ulons);
angs = angs(2:2:size(angs,1),2:2:size(angs,2));
angs(angs>pi)  = 0;
angs(angs<-pi) = 0;

%zz = interp2(zinfo.lons,zinfo.lats,zinfo.Z,tlons,tlats);
zz = interp_z(zinfo,tlats,tlons);

%%
fd = fopen('global.grid','w','s');

fwrite(fd,ulats*pi/180,'double');
fwrite(fd,ulons*pi/180,'double');
fwrite(fd,htn/1e5,'double');
fwrite(fd,hte/1e5,'double');
fwrite(fd,hus/1e5,'double');
fwrite(fd,huw/1e5,'double');
fwrite(fd,angs,'double');

fclose(fd);

fprintf('Grid file created!\n');

info = struct(...
    'tlats',tlats, ...
    'tlons',tlons, ...
    'ulats',ulats, ...
    'ulons',ulons, ...
    'hte',  hte,   ...
    'htn',  htn,   ...
    'hus',  hus,   ...
    'huw',  huw,   ...
    'angle',angs*180/pi, ...
    'z',    zz );

%%
if PLOT == 0
    return;
end

figure; 

hte(zz>0) = NaN;
subplot(2,2,1); pcolor(hte'); shading flat; colormap jet; colorbar; daspect([1 1 1]); title('HTE'); 
hold on; contour(hte'>thres);

htn(zz>0) = NaN;
subplot(2,2,2); pcolor(htn'); shading flat; colormap jet; colorbar; daspect([1 1 1]); title('HTN');
hold on; contour(htn'>thres);

hus(zz>0) = NaN;
subplot(2,2,3); pcolor(hus'); shading flat; colormap jet; colorbar; daspect([1 1 1]); title('HUS'); 
hold on; contour(hus'>thres);

huw(zz>0) = NaN;
subplot(2,2,4); pcolor(htn'); shading flat; colormap jet; colorbar; daspect([1 1 1]); title('HUW');
hold on; contour(huw'>thres);

figure;
pcolor(angs'); shading flat; colormap jet; colorbar; daspect([1 1 1]); title('ANGLE');

end