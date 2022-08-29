function [xs,ys,angles]=plot_ellipses(as,bs,varargin)
% PLOT_ELLIPSES: plot embedded ellipses 
%   plot_ellipses(as,bs,varargin)
%       as: long axis, bs: short axis
%       varargin{1}: optional locations of ellipse center
%

%% 
PLOT_FLAG = 0;
SEGS = 360;

%SCHEME = 2;  % Forward
SCHEME = 3;  % Backward
%SCHEME = 4;   % Backward-Newton

ctrs = zeros(numel(as),1);
if numel(varargin) >= 1
    ctrs = varargin{1};
end

if numel(varargin) > 1
    SEGS = varargin{2};
end
assert(floor(SEGS/2)*2 == SEGS);


%% 
THRES = 0.0625;
II = SEGS * THRES;


%%
xs = ones(numel(as),SEGS+1)*NaN;
ys = xs;
angles = xs;

%% Radial lines
if SCHEME == 1
    for i = 1 : numel(as)
        a = as(i); b = bs(i);
        %t = [ 2*pi : -2*pi/SEGS : 0 ];
        t = [ 0 : 2*pi/SEGS : 2*pi ];
        x = a*cos(t)+ctrs(i); y = b*sin(t);
        xs(i,:) = x;
        ys(i,:) = y;
        if PLOT_FLAG == 1
            plot(x,y); hold on; daspect([1 1 1]);
        end
    end
end

%% Forward Eulerian
if SCHEME == 2
    %t = [2*pi : -2*pi/SEGS : 0];
    t = [ 0 : 2*pi/SEGS : 2*pi ];
    x = as(numel(as))*cos(t)+ctrs(numel(as));  y = bs(numel(as))*sin(t);
    xs(numel(as),:) = x;
    ys(numel(as),:) = y;
    
    pgs = ProgressBar(numel(as));
    for i = numel(as)-1:-1:1
        %fprintf('%d of %d\n',i,numel(as));
        pa = as(i+1);  pb = bs(i+1);  pctr = ctrs(i+1);
        ca = as(i);    cb = bs(i);    cctr = ctrs(i);   
        
        pxs = xs(i+1,1:SEGS/2+1);
        [cxs,cys,~,cangles] = find_ellip_loc(pa,pb,pctr,ca,cb,cctr,pxs);
        
        if i < II-1
            CII = II - i;
            fprintf('Hardwiring %d (cur-II=%d)\n',i,CII);
            cysB1 = cys(CII+1) * [0:CII-1] / CII;
            cxsB1 = sqrt(1- (cysB1/bs(i)).^2)*as(i) +ctrs(i);
            
            cxs(1:CII) = cxsB1;
            cys(1:CII) = cysB1;
            
            cysB2 = cys(SEGS/2+1-CII) * [CII-1:-1:0] / CII;
            cxsB2 =-sqrt(1- (cysB2/bs(i)).^2)*as(i) +ctrs(i);
            
            cxs(SEGS/2+2-CII:SEGS/2+1) = cxsB2;
            cys(SEGS/2+2-CII:SEGS/2+1) = cysB2;
        end
        
        xs    (i,1:SEGS/2+1) =  cxs;
        ys    (i,1:SEGS/2+1) = -cys;
        angles(i,1:SEGS/2+1) = -cangles;
        
        xs    (i,SEGS/2+2:SEGS+1) = cxs(SEGS/2:-1:1);
        ys    (i,SEGS/2+2:SEGS+1) = cys(SEGS/2:-1:1);
        angles(i,SEGS/2+2:SEGS+1) = cangles(SEGS/2:-1:1);
        
        pgs.progress;
    end
    pgs.stop;
end

%% Backward Eulerian Simplified (3) or Newton (4)
if SCHEME == 3 || SCHEME == 4
    %t = [2*pi : -2*pi/SEGS : 0];
    t = [ 0 : 2*pi/SEGS : 2*pi ];
    x = as(numel(as))*cos(t)+ctrs(numel(as));  y = bs(numel(as))*sin(t);
    xs(numel(as),:) = x;
    ys(numel(as),:) = y;
    
    pgs = ProgressBar(numel(as));
    for i = numel(as)-1:-1:1
        pa = as(i+1);  pb = bs(i+1);  pctr = ctrs(i+1);
        ca = as(i);    cb = bs(i);    cctr = ctrs(i);
        
        pxs = xs(i+1,1:SEGS/2+1);
        if SCHEME == 3
            [cxs,cys,~,cangles] = find_ellip_loc_backward(pa,pb,pctr,ca,cb,cctr,pxs);
        else
            [cxs,cys,~,cangles] = find_ellip_loc_backward_newton(pa,pb,pctr,ca,cb,cctr,pxs);
        end
        
        if i < II-1
            CII = II - i;
            fprintf('Hardwiring %d (cur-II=%d)\n',i,CII);
            cysB1 = cys(CII+1) * [0:CII-1] / CII;
            cxsB1 = sqrt(1- (cysB1/bs(i)).^2)*as(i) +ctrs(i);
            
            cxs(1:CII) = cxsB1;
            cys(1:CII) = cysB1;
            
            cysB2 = cys(SEGS/2+1-CII) * [CII-1:-1:0] / CII;
            cxsB2 =-sqrt(1- (cysB2/bs(i)).^2)*as(i) +ctrs(i);
            
            cxs(SEGS/2+2-CII:SEGS/2+1) = cxsB2;
            cys(SEGS/2+2-CII:SEGS/2+1) = cysB2;
        end
        
        xs    (i,1:SEGS/2+1) =  cxs;
        ys    (i,1:SEGS/2+1) = -cys;
        angles(i,1:SEGS/2+1) = -cangles;
        
        xs    (i,SEGS/2+2:SEGS+1) = cxs(SEGS/2:-1:1);
        ys    (i,SEGS/2+2:SEGS+1) = cys(SEGS/2:-1:1);
        angles(i,SEGS/2+2:SEGS+1) = cangles(SEGS/2:-1:1);
        
        pgs.progress;
    end
    pgs.stop;
end

%% A mixture to mitigate between 1 and 3
if SCHEME == 5
    %t = [2*pi : -2*pi/SEGS : 0];
    t = [ 0 : 2*pi/SEGS : 2*pi ];
    x = as(numel(as))*cos(t)+ctrs(numel(as));  y = bs(numel(as))*sin(t);
    xs(numel(as),:) = x;
    ys(numel(as),:) = y;
    
    ws_1 = generate_weights(SEGS/2);
    
    pgs = ProgressBar(numel(as));
    for i = numel(as)-1:-1:1
        pa = as(i+1);  pb = bs(i+1);  pctr = ctrs(i+1);
        ca = as(i);    cb = bs(i);    cctr = ctrs(i);
        
        pxs = xs(i+1,1:SEGS/2+1);
        [cxs,cys,~,cangles] = find_ellip_loc_backward(pa,pb,pctr,ca,cb,cctr,pxs,0,ws_1);
            
        xs    (i,1:SEGS/2+1) =  cxs;
        ys    (i,1:SEGS/2+1) = -cys;
        angles(i,1:SEGS/2+1) = -cangles;
        
        xs    (i,SEGS/2+2:SEGS+1) = cxs(SEGS/2:-1:1);
        ys    (i,SEGS/2+2:SEGS+1) = cys(SEGS/2:-1:1);
        angles(i,SEGS/2+2:SEGS+1) = cangles(SEGS/2:-1:1);
        
        pgs.progress;
    end
    pgs.stop;
end

    function WS = generate_weights(SC)
        xx = [-1 : 2/SC : 1];
        WS = (1-cos(pi*(xx.^4)))/4;
    end

end