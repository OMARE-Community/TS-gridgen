function [as,bs,ctrs] = make_as_bs_ctrs_240(lon,lats,lat_outer,res_ratio,pole_lat)

%%
RADIUS = 90;

BRES = 1/240;

%%
m_proj('stereographic','lon',lon+90,'lat',90,'rad',RADIUS);

[rw,~] = m_ll2xy(lon,    lats(1)  );
[re,~] = m_ll2xy(lon+180,lats(2)  );
[ro,~] = m_ll2xy(lon+180,lat_outer);

%%
clat = lat_outer;

csteps = zeros(0,1);
while clat < 90
    cnt = 0;
    while cnt < res_ratio
       lat_equiv = (clat-lat_outer)/(90-lat_outer)*(pole_lat-lat_outer) + lat_outer;
       cstep = BRES / secd(lat_equiv);
       clat = clat + cstep;
       csteps = [csteps; cstep];
       
       cnt = cnt + 1;
    end
end

if clat > 90
    %csteps = csteps * (90-LAT_OUTER) / (sum(csteps)); 
    extra = clat - 90;
    extras = extra * [0:1:numel(csteps)-1]' / sum([0:1:numel(csteps)-1]);
    fprintf('Compensating %.2e degrees (%.2f%% not compensated)\n',extra,abs(100-100*sum(extras)/extra));
    csteps = csteps - extras;
end
llats = lat_outer * ones(numel(csteps)+1,1);
for i = 1 : numel(csteps)
    llats(i+1) = llats(i+1) + sum(csteps(1:i));
end

llats = llats(numel(llats):-1:1);
[rs,~] = m_ll2xy(lon+180,llats);
rs = rs / ro;

aw = compute_a_from_b(rs,-rw/ro);
ae = compute_a_from_b(rs, re/ro);

as = (aw+ae)/2;
bs = rs;
ctrs = (ae-aw)/2;

end