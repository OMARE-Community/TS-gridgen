function [as,bs,cs] = make_ellipses( res )

%%
[LON,LATS,ILAT,SLAT] = make_config;

%%
lats = zeros(1,1);

%%
clat = 0;
csteps = zeros(0,1);
while clat < ILAT
    cstep = res / secd(clat);
    clat = clat + cstep;
    lats = [ lats; clat ];
    csteps = [csteps; cstep];
end
BOUND_LAT = clat;

%%
NPOLE_LAT = mean(LATS);
%POLE_LAT = mean([POLE_LAT,90]);
NPOLE_LAT = (90-NPOLE_LAT)/2.5+NPOLE_LAT;

%%
clat = 0;
while clat > SLAT
    if clat > -10
        cstep = res / secd(clat);
    else
        cstep = res / secd( clat / ((clat/(-10))^0.04) );
    end
    clat = clat - cstep;
    lats = [ clat; lats ];
    csteps = [ cstep; csteps ];
end

MAX_SLAT = floor(min(lats));

%%
m_proj('stereographic','lon',LON+90,'lat',90,'rad',90-MAX_SLAT);
[radii,~] = m_ll2xy(LON+180, lats);

%%
[rw,~] = m_ll2xy(LON,    LATS(1)  );
[re,~] = m_ll2xy(LON+180,LATS(2)  );
[ro,~] = m_ll2xy(LON+180,BOUND_LAT);

clat = BOUND_LAT;
ncsteps = zeros(0,1);
while clat < 90
    lat_equiv = (clat-BOUND_LAT)/(90-BOUND_LAT)*(NPOLE_LAT-BOUND_LAT) + BOUND_LAT;
    cstep = res / secd(lat_equiv);
    clat = clat + cstep;
    ncsteps = [ ncsteps; cstep];
end
    
if clat > 90
    extra = clat - 90;
    extras = extra * [0:1:numel(ncsteps)-1]' / sum([0:1:numel(ncsteps)-1]);
    fprintf('Compensating %.2e degrees (%.2f%% not compensated)\n',extra,abs(100-100*sum(extras)/extra));
    ncsteps = ncsteps - extras;
end

nlats = BOUND_LAT * ones(numel(ncsteps),1);
for i = 1 : numel(ncsteps)
    nlats(i) = nlats(i) + sum(ncsteps(1:i));
end
    
[rs,~] = m_ll2xy(LON+180,nlats);
rs = rs / ro;

aw = compute_a_from_b(rs,-rw/ro);
ae = compute_a_from_b(rs, re/ro);

%%
as = [ radii; (aw+ae)*ro/2 ];
bs = [ radii; rs*ro ];
cs = [ zeros(numel(radii),1); (ae-aw)*ro/2 ];

%%
%plot_ellipses(as,bs,cs);

end