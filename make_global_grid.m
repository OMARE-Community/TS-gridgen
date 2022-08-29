function [lats,lons,angs]=make_global_grid(res,varargin)

PLOT = 0;
if numel(varargin) > 0
    PLOT = varargin{1};
end

SKIP = 10;

%%
[nlats,nlons,nangs] = make_north_hemis_grid(res);
[slats,slons] = make_south_hemis_grid(res,res,0,nlons(1));

lats = [ slats, nlats' ];
lons = [ slons, nlons' ];
lons = lons - 360*(lons> 180);
lons = lons + 360*(lons<-180);

angs = [ zeros(size(slats)), nangs' ];

%%
if PLOT >= 1
    figure; 
    if size(lats,1) > 1000
        SKIP = 100;
    end
    %plot_grid(lats(:,:),lons(:,:),'skip',SKIP,'region','Global');
    plot_grid(lats(:,:),lons(:,:),'skip',SKIP,'region','NP');
    %plot_grid(lats(:,:),lons(:,:),'skip',SKIP,'region','NP-Greenland');
    hold on;
    
    if PLOT > 1
        %[hte,htn] = compute_cell_edge_sizes(lats,lons);
        [hte,htn] = compute_cell_sizes(lats,lons);
        %hte(hte>12)=12;  htn(htn>12)=12;
    
        M = size(lats,1);  N = size(lats,2);
        m_contourf(lons(1:M-1,1:N-1),lats(1:M-1,1:N-1),htn); shading flat; colormap jet; colorbar;
    
        m_coast('patch',[.5 .5 .5],'edgecolor','None');
    end
end

end