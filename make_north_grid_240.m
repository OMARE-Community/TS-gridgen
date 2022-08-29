function [lats,lons,zs] = make_north_grid_240(res,zinfo)

%%
[LON,LATS,ILAT,POLE_LAT] = make_latlon_config;

%%
SEGS = 240*360;
BRES = 1/240;
RATIO = round(res/BRES);

%%
clat = 0;
csteps = zeros(0,1);
while clat < ILAT
    CNT = 0;
    while CNT < RATIO
        cstep = BRES / secd(clat);
        clat = clat + cstep;
        csteps = [csteps; cstep];
        
        CNT = CNT + 1;
    end
end

llats = zeros(numel(csteps),1);
for i = 1 : numel(csteps)-1
    llats(i+1) = llats(i+1) + sum(csteps(1:i));
end

fprintf('Turning latitude: %.3fN at %d\n',clat,i);

%%
m_proj('stereographic','lon',LON+90,'lat',90,'rad',RADIUS);

[as,bs,ctrs] = make_as_bs_ctrs_240(LON,LATS,clat,RATIO,POLE_LAT);

steps = (numel(aw)-1)/RATIO;

cxs = as(numel(as))*cos([ 0 : 2*pi/SEGS : 2*pi ]) + ctrs(numel(as));  
cys = bs(numel(as))*sin([ 0 : 2*pi/SEGS : 2*pi ]);

for i = 1 : steps
    cas  = as  ( i*RATIO+1 : -1: (i-1)*STEPS+1 );
    cbs  = bs  ( i*RATIO+1 : -1: (i-1)*STEPS+1 );
    ctrs = ctrs( i*RATIO+1 : -1: (i-1)*STEPS+1 );
    
    [cxs,cys] = step_NC_240(cxs,cys,cas,cbs,cctrs);
    
    %% Conver to Lat-Lon
    %% Find mean(Z)
end
