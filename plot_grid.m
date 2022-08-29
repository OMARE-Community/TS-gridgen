function plot_grid( lats, lons, varargin )

[lats,lons,lmask,cdata,SKIP,proj_opts,grid_opts,lcolor,SLT_INFO] = parse_args(lats,lons,varargin{:});
IDX = -1;
vals = [];

lonsR = lons - 360*(lons>180);
lonsR = lonsR + 360*(lonsR<-180);

%figure;
m_proj(proj_opts{:});
%m_proj('stereographic','lon',0,'lat',90,'rad',90);

%m_contourf(lons(1:UPTO,1:270),lats(1:UPTO,1:270),vals(1:UPTO,1:270),[20 40 60 80 100 140 180]);
%m_contourf(lonsR(1:UPTO,181:360),lats(1:UPTO,181:360),vals(1:UPTO,181:360),[20 40 60 80 100 140 180]);
%m_contourf(lonsR(1:UPTO,1:360),lats(1:UPTO,1:360),vals(1:UPTO,1:360)); 
%m_contourf(lonsR(1:UPTO,:),lats(1:UPTO,:),sind(lats(1:UPTO,:))); 
%shading flat;
%colorbar;

if numel(vals) > 0
val_refs = [5 10 20 50 75 100 150 200];
cmap = jet(64);
for i = 1 : size(lats,1)-1
    for j = 1 : size(lats,2)-1
        clats = [ lats(i,j), lats(i+1,j), lats(i+1,j+1), lats(i,j+1), lats(i,j) ];
        clons = [ lons(i,j), lons(i+1,j), lons(i+1,j+1), lons(i,j+1), lons(i,j) ];
        clons = clons - 360*(clons > 180);
        h=m_patch(clons,clats,rand(1,3),'LineStyle','None');
        %set(h,'LineStyle','None');
    end
end
end

if ~isnumeric(cdata)
    m_pcolor(cdata.lons,cdata.lats,cdata.data); colormap winter; hold on;
    %m_contour(cdata.lons,cdata.lats,cdata.data>5,'edgecolor','k'); %shading flat; colorbar;
end

if lmask == 1
    m_coast('patch',[.5 .5 .5],'edgecolor','None');
    %m_gshhs_l('patch',[.5 .5 .5],'edgecolor','None');
    %m_gshhs_i('patch',[.5 .5 .5],'edgecolor','None');
    %m_gshhs_h('patch',[.5 .5 .5],'edgecolor','None');
else
    
end

m_grid(grid_opts{:});
title(sprintf('SKIP:%d',SKIP));

colors = struct('val',{'k','r','g','b'});
colors = struct('val',{'k','k','r','g','b'});

for i = 1 : SKIP : size(lats,1)-1
    for j = 1 : SKIP : size(lats,2)-1
        cur_lats = []; cur_lons = [];
        
        % Zonal
        UB = min(j+SKIP,size(lats,2));
        cur_lons = lonsR(i,j:UB);
        cur_lats = lats (i,j:UB);
        [ cur_lons, cur_lats ] = regulate_lons(cur_lons,cur_lats);
        %fprintf('%d %d %.3f %.3f\n',i,j,cur_lons(1).vals(1),cur_lats(1).vals(1));
        
        if numel(SLT_INFO) > 0
            flgs = SLT_INFO.Z(i,j:UB-1);
            
            if nnz(flgs) == 0
                for k = 1 : numel(cur_lons)
                    m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(k).val);
                end
            else
                [ cur_lons, cur_lats ] = regulate_lons(lonsR(i,j:UB),lats(i,j:UB),flgs);
                for k = 1 : numel(cur_lons)
                    m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(k).val);
                end
            end
%             for k = 1 : numel(cur_lons)
%                 plt_flg = 1;
%                 if k > numel(flgs)
%                     plt_flg = 1;
%                 elseif flgs(k) == 1
%                     plt_flg = 0;
%                     fprintf('M : %d, %d\n',i,j+k-1);
%                 end
%                 if plt_flg == 1
%                     m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(k).val);
%                 end
%             end
        else
            for k = 1 : numel(cur_lons)
                %m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(k).val);
                m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',lcolor);
            end
        end
        
        % Meridional
        UB = min(i+SKIP,size(lats,1));
        cur_lons = lonsR(i:UB,j);
        cur_lats = lats (i:UB,j);
        [ cur_lons, cur_lats ] = regulate_lons(cur_lons,cur_lats);
        %fprintf('%d %d %.3f %.3f\n',i,j,cur_lons(1).vals(1),cur_lats(1).vals(1));
        
        if numel(SLT_INFO) > 0
            flgs = SLT_INFO.M(i:UB-1,j);
            
            if nnz(flgs) == 0
                for k = 1 : numel(cur_lons)
                    m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(k).val);
                end
            else
                [ cur_lons, cur_lats ] = regulate_lons(lonsR(i:UB,j),lats(i:UB,j),flgs);
                for k = 1 : numel(cur_lons)
                    m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(k).val);
                end
            end
%             for k = 1 : numel(cur_lons)
%                 plt_flg = 1;
%                 if k > numel(flgs)
%                     plt_flg = 1;
%                 elseif flgs(k) == 1
%                     plt_flg = 0;
%                     fprintf('Z : %d, %d\n',i+k-1,j);
%                 end
%                 if plt_flg == 1
%                     m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(k).val);
%                 end
%             end
        else
            for k = 1 : numel(cur_lons)
                %m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(3).val);
                m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',lcolor);
            end
        end
    end
end

%m_line(lonsR(size(lats,1),:),lats(size(lats,1),:),'color','r');
cur_lons = lonsR(size(lats,1),:);
cur_lats = lats(size(lats,1),:);
cur_lons = cur_lons - 360*(cur_lons == 180);
[ cur_lons, cur_lats ] = regulate_lons(cur_lons,cur_lats);
%fprintf('%d %d %.3f %.3f\n',i,j,cur_lons(1).vals(1),cur_lats(1).vals(1));
for k = 1 : numel(cur_lons)
    m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(k).val);
end

%m_line(lonsR(:,size(lats,2)),lats(:,size(lats,2)),'color','g');
cur_lons = lonsR(:,size(lats,2));
cur_lats = lats(:,size(lats,2));
cur_lons = cur_lons - 360*(cur_lons == 180);
[ cur_lons, cur_lats ] = regulate_lons(cur_lons,cur_lats);
%fprintf('%d %d %.3f %.3f\n',i,j,cur_lons(1).vals(1),cur_lats(1).vals(1));
for k = 1 : numel(cur_lons)
    m_line(cur_lons(k).vals, cur_lats(k).vals, 'color',colors(k).val);
end

% Draw NP boundary
if IDX > 0
    rlats = lats(IDX,:);
    rlons = lonsR(IDX,:);
    BREAK = 0;
    for i = 1 : numel(rlons)-1
        if rlons(i+1) < rlons(i)
            BREAK = i;
            break;
        end
    end
    m_line(rlons(1:BREAK),rlats(1:BREAK),'color','b','linewidth',2);
    m_line(rlons(BREAK+1:numel(rlons)),rlats(BREAK+1:numel(rlons)),'color','b','linewidth',2);
end

    function [lats,lons,lmask,cdata,skip,proj_opts,grid_opts,l_color,slts] = parse_args(varargin)
        p = inputParser;
        defaultLMASK = 1;
        defaultSKIP = max(10,compute_log_step(sqrt(numel(varargin{1}))/100));
        defaultREGN = 'Global';
        defaultCDATA = 0;
        defaultSLITS = [];
        defaultALIGN = 0;
        defaultALIGNLAT = 45;
        defaultALIGNLON = -100;
        defaultLCOLOR = 'k';

        expectedREGNs = {'Globe','Global','NP','NP-Greenland','SP','SE-Asia','NE-Asia','NP-NA','POM-Asia','AT-SAF','Baltic','CAA'};

        addRequired(p,'lats',@isnumeric);
        addRequired(p,'lons',@isnumeric);
        addParamValue(p,'lmask',defaultLMASK,@isnumeric);
        addParamValue(p,'data',defaultCDATA);
        addParamValue(p,'skip',defaultSKIP,@isnumeric);
        addParamValue(p,'region',defaultREGN,...
                     @(x) any(validatestring(x,expectedREGNs)));
        addParamValue(p,'slits',defaultSLITS);
        addParamValue(p,'alon',defaultALIGN);
        addParamValue(p,'clat',defaultALIGNLAT);
        addParamValue(p,'clon',defaultALIGNLON);
        addParamValue(p,'lcolor',defaultLCOLOR);

        parse(p,varargin{:});

        lats = p.Results.lats;
        lons = p.Results.lons;
        lmask = p.Results.lmask;
        l_color = p.Results.lcolor;
        cdata = p.Results.data;
        skip = p.Results.skip;
        assert( (skip > 0) && (floor(skip) == skip) );
        if strcmp(p.Results.region,'Globe') == 1
            proj_opts = {'ortho','lat',p.Results.clat,'long',p.Results.clon};
            grid_opts = {'xtick',[-180:90:180],'tickdir','out','ytick',[-75,-30,0,30,75],'linest','--','fontsize',18};
            crop_opts = struct('minlat',-95,'maxlat',95,'minlon',-185,'maxlon',365);
        elseif strcmp(p.Results.region,'Global') == 1
            proj_opts = {'Miller Cylindrical','longitude',p.Results.alon};
            %proj_opts = {'Miller Cylindrical','longitude',lons(1)-180};
            grid_opts = {'xtick',[-180:45:180],'tickdir','out','ytick',[-75,-30,0,30,75],'linest','--','fontsize',18};
            crop_opts = struct('minlat',-95,'maxlat',95,'minlon',-185,'maxlon',365);
        elseif strcmp(p.Results.region,'NP') == 1
            %proj_opts = {'stereographic','lon',-40,'lat',90,'rad',65};
            proj_opts = {'stereographic','lon',-40,'lat',90,'rad',50};
            grid_opts = {'xtick',[0,180],'tickdir','out','ytick',[-30,0,30,60],'linest','--','fontsize',18};
            crop_opts = struct('minlat',30,'maxlat',95,'minlon',-185,'maxlon',185);
        elseif strcmp(p.Results.region,'NP-Greenland') == 1
            proj_opts = {'stereographic','longitude',-42,'latitude',81,'radius',36};
            grid_opts = {'xtick',[-180:45:180],'tickdir','out','ytick',[0,30,60],'linest','--','fontsize',18};
            crop_opts = struct('minlat',20,'maxlat',95,'minlon',-185,'maxlon',185);
        elseif strcmp(p.Results.region,'CAA') == 1
            proj_opts = {'stereographic','longitude',-100,'latitude',75,'radius',18};
            grid_opts = {'xtick',[-180:30:180],'tickdir','out','ytick',[20,40,60,80],'linest','--','fontsize',18};
            crop_opts = struct('minlat',20,'maxlat',95,'minlon',-185,'maxlon',185);
        elseif strcmp(p.Results.region,'SP') == 1
            proj_opts = {'stereographic','longitude',0,'latitude',-90,'radius',50};
            grid_opts = {'xtick',[-180:45:180],'tickdir','out','ytick',[-45,0,45],'linest','--','fontsize',18};
            crop_opts = struct('minlat',-95,'maxlat',-30,'minlon',-185,'maxlon',185);
        elseif strcmp(p.Results.region,'SE-Asia') == 1
            proj_opts = {'Miller Cylindrical','longitude',0,'lon',[60 140],'lat',[5 45]};
            grid_opts = {'xtick',[-180:10:180],'tickdir','out','ytick',[-70:10:70],'linest','--','fontsize',18};
            crop_opts = struct('minlat',0,'maxlat',50,'minlon',55,'maxlon',145);
        elseif strcmp(p.Results.region,'NE-Asia') == 1
            proj_opts = {'Miller Cylindrical','longitude',0,'lon',[100 160],'lat',[25 60]};
            grid_opts = {'xtick',[-180:10:180],'tickdir','out','ytick',[-70:10:70],'linest','--','fontsize',18};
            crop_opts = struct('minlat',20,'maxlat',65,'minlon',95,'maxlon',175);
        elseif strcmp(p.Results.region,'NP-NA') == 1
            proj_opts = {'lambert','long',[-167.5 -102.5],'lat',[20 65]};
            grid_opts = {'xtick',[-180:10:180],'tickdir','out','ytick',[-70:10:70],'linest','--','fontsize',18};
            crop_opts = struct('minlat',15,'maxlat',70,'minlon',-180,'maxlon',-90);
        elseif strcmp(p.Results.region,'POM-Asia') == 1
            proj_opts = {'lambert','long',[85 145],'lat',[-15 35]};
            grid_opts = {'xtick',[-180:10:180],'tickdir','out','ytick',[-70:10:70],'linest','--','fontsize',18};
            crop_opts = struct('minlat',-20,'maxlat',40,'minlon',80,'maxlon',150);
        elseif strcmp(p.Results.region,'AT-SAF') == 1
            proj_opts = {'Miller Cylindrical','longitude',0,'lon',[5 20],'lat',[-30 -10]};
            grid_opts = {'xtick',[-180:10:180],'tickdir','out','ytick',[-70:10:70],'linest','--','fontsize',18};
            crop_opts = struct('minlat',-35,'maxlat',-5,'minlon',0,'maxlon',25);
            %crop_opts = struct('minlat',-85,'maxlat',90,'minlon',-180,'maxlon',180);
        elseif strcmp(p.Results.region,'Baltic') == 1
            proj_opts = {'lambert','long',[5 35],'lat',[50 70]};
            grid_opts = {'xtick',[-180:10:180],'tickdir','out','ytick',[-70:10:70],'linest','--','fontsize',18};
            crop_opts = struct('minlat',45,'maxlat',75,'minlon',0,'maxlon',40);
            %crop_opts = struct('minlat',-85,'maxlat',90,'minlon',-180,'maxlon',180);
        end
        slts = p.Results.slits;

        [lats,lons] = crop_latlons(lats,lons,crop_opts);
    end

    function [nlats,nlons] = crop_latlons(olats,olons,copts)
        [m,n] = size(olats);
        cr_i_stt = 0;
        cr_i_stp = 0;
        cr_j_stt = 0;
        cr_j_stp = 0;

        maxlats = max(olats);
        minlats = min(olats);
        jj = 1;
        while jj <= n && maxlats(jj) < copts.minlat
            jj = jj + 1;
        end 
        cr_j_stt = max(1,jj);
        while jj <= n && minlats(jj) < copts.maxlat
            jj = jj + 1;
        end
        cr_j_stp = min(jj,n);
            
        tmplats = olats(:,cr_j_stt:cr_j_stp);
        tmplons = olons(:,cr_j_stt:cr_j_stp);

        maxlons = max(tmplons');
        minlons = min(tmplons');
        ii = 1;
        while ii <= m && maxlons(ii) < copts.minlon
            ii = ii + 1;
        end 
        cr_i_stt = max(1,ii);
        while ii <= m && minlons(ii) < copts.maxlon
            ii = ii + 1;
        end
        cr_i_stp = min(m,ii);
 
        nlats = tmplats(cr_i_stt:cr_i_stp,:);
        nlons = tmplons(cr_i_stt:cr_i_stp,:);
        
        fprintf('Cropped to %.2f of the original matrix.\n',numel(nlats)*100/numel(olats));
    end
end

