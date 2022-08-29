function [lons,lats,angs]=plot_poles(lon,lats,varargin)

%%
LAT_OUTER = 15;
if numel(varargin) > 0
    LAT_OUTER = varargin{1};
end

CLAT = 90;
if lats(1) < 0
    CLAT = -90;
end

%%
POLE_LAT = mean(lats);
%POLE_LAT = mean([POLE_LAT,90]);
POLE_LAT = (90-POLE_LAT)/2.5+POLE_LAT;

%%
RES = 1;
if numel(varargin) > 1
    RES = varargin{2};
    if RES > 20
        RES = 1 / RES;
    end
end

%%
POLAR_REF_OPT = 3;

%%
RADIUS = 90;
%RADIUS = 10;  CLAT = 82.5;

%%
PLOT_ZONAL = 1;
PLOT_MERID = 0;

%%
m_proj('stereographic','lon',lon+90,'lat',CLAT,'rad',RADIUS);
if PLOT_ZONAL + PLOT_MERID > 0
    m_coast; m_grid;
    %mgrid('xtick',[0 45 90 180],'ytick',[75 80 85]); 

    m_line(lon,    lats(1),'marker','square','color','r');
    m_line(lon+180,lats(2),'marker','square','color','r');
end

%%
[rw,~] = m_ll2xy(lon,    lats(1)  );
[re,~] = m_ll2xy(lon+180,lats(2)  );
[ro,~] = m_ll2xy(lon+180,LAT_OUTER);

if POLAR_REF_OPT == 0       % Equal on Polar Stereographic Projection
    STT = 0;
    STP = 1/((90-LAT_OUTER)/RES);
    rs = [STT : STP : 1];
elseif POLAR_REF_OPT == 1   % Equal on Meridional Direction
    SLATS = [LAT_OUTER:RES:90];
    SLATS = SLATS(numel(SLATS):-1:1);
    [rs,~] = m_ll2xy(lon+180,SLATS);
    rs = rs / ro;
elseif POLAR_REF_OPT == 3   % Mercator Projection
    clat = LAT_OUTER;
    csteps = zeros(0,1);
    while clat < 90
        lat_equiv = (clat-LAT_OUTER)/(90-LAT_OUTER)*(POLE_LAT-LAT_OUTER) + LAT_OUTER;
        cstep = RES / secd(lat_equiv);
        clat = clat + cstep;
        csteps = [csteps; cstep];
    end
    
    if clat > 90
        %csteps = csteps * (90-LAT_OUTER) / (sum(csteps)); 
        extra = clat - 90;
        extras = extra * [0:1:numel(csteps)-1]' / sum([0:1:numel(csteps)-1]);
        fprintf('Compensating %.2e degrees (%.2f%% not compensated)\n',extra,abs(100-100*sum(extras)/extra));
        csteps = csteps - extras;
    end
    llats = LAT_OUTER * ones(numel(csteps)+1,1);
    for i = 1 : numel(csteps)
        llats(i+1) = llats(i+1) + sum(csteps(1:i));
    end
    
    llats = llats(numel(llats):-1:1);
    [rs,~] = m_ll2xy(lon+180,llats);
    rs = rs / ro;
    rs(rs<0) = 0;
end

aw = compute_a_from_b(rs,-rw/ro);
ae = compute_a_from_b(rs, re/ro);
[xs,ys,angs] = plot_ellipses((aw+ae)/2,rs,(ae-aw)/2,round(360/RES));

[lons,lats] = m_xy2ll(xs*ro,ys*ro);
latmean = (lats(:,round(size(lats,2)/8)) + lats(:,round(size(lats,2)*3/8)))/2;
latmean = sort(latmean);
%[tlons,tlats]=m_xy2ll(xs(10,:)*ro,ys(10,:)*ro)

%%
if PLOT_ZONAL == 1
    m_line(lons(1,:),lats(1,:),'color','r');
    for i = 2 : size(lons,1)-1
        if (i == size(lons,1)-2) || (i == size(lons,1)-3)   
            m_line(lons(i,:),lats(i,:),'color','k','linewidth',2);
        else
            m_line(lons(i,:),lats(i,:),'color','k');
        end
    end
    i = size(lons,1);
    m_line(lons(i,:),lats(i,:),'color','r');
end
if PLOT_MERID == 1
    m_line(lons(:,1),lats(:,1),'color','r');
    for i = 2 : size(lons,2)
        m_line(lons(:,i),lats(:,i),'color','k');
    end
end

end