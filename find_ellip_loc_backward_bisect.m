function [xi,yi,yo,angles] = find_ellip_loc_backward_bisect(ao,bo,co,ai,bi,ci,xo,varargin)

ITER_COUNT_MAX = 1000;
EPS = 1e-13;
PROP = 0.1;

%%
PLOT = 0;
if numel(varargin) > 0
    PLOT = varargin{1};
end

%% Special case of innermost ellipse
if bi == 0
    [xi,yi,yo,angles] = find_ellip_loc(ao,bo,co,ai,bi,ci,xo,PLOT);
    
else
    yo = -bo*sqrt(1-(xo-co).*(xo-co)/(ao*ao));

    % Initial guesses
    [cxs,~] = line_ellipse_intersection(xo,yo,ci*ones(size(xo)),zeros(size(xo)),ai,bi,ci);
    
    ncvgs = ones(size(xo));
    
    xls = (ci-bi)*ones(size(xo));
    xrs = (ci+bi)*ones(size(xo));
    
    xls(cxs> ci) = cxs(cxs> ci);
    xrs(cxs<=ci) = cxs(cxs<=ci);
    
    distsl = eval_dists(xo,yo,xls,ai,bi);
    distsr = eval_dists(xo,yo,xls,ai,bi);
    
    iter_count = 0;
    while (iter < ITER_COUNT_MAX) && sum(ncvgs) > 0
        iter_count = iter_count + 1;
        
        xcs = (xls+xrs)/2;
        distsc = eval_dists(xo,yo,xcs,ai,bi);
        
        
    end
    if iter_count == ITER_COUNT_MAX
        fprintf('Potential unconvergent solutions!\n');
    end
    
    %%
    cys = -bi*sqrt(1-cxs.*cxs/(ai*ai));
    cxs = cxs + ci;
    
    %%
    xi = real(cxs);
    yi = real(cys);
    
    %%
    slopeT = -(xi-ci)*bi*bi./(yi*ai*ai);

    angles = -angle(complex(xi,yi))-pi/2 + atan(slopeT);
    %angles = zeros(size(xi));
    if nnz(abs(imag(angles))>0) > 0
        fprintf('ERROR!\n');
    end

end

%%
if PLOT == 1
    figure;
    
    plot_ellipse(ao,bo,co); hold on;
    plot_ellipse(ai,bi,ci); daspect([1 1 1]);
    
    STEP = 0.1;
    for i = 1 : numel(xo)
        %plot([xo(i)-STEP,xo(i)+STEP],[-slopeT(i)*STEP+yo(i),slopeT(i)*STEP+yo(i)],'--');
        %%plot([xo(i)-STEP,xo(i)+STEP],[-slopeN(i)*STEP+yo(i),slopeN(i)*STEP+yo(i)],'--');
        %plot([xo(i)-STEP*p(i),xo(i)+STEP*p(i)],[yo(i)-STEP,yo(i)+STEP],'--');
        
        plot([xo(i),xi(i)],[yo(i),yi(i)],'-*');
    end
end

    function plot_ellipse(aa,bb,cc)
        RES = pi/1800;
        xx = aa*cos([0:RES:2*pi])+cc;
        yy = bb*sin([0:RES:2*pi]);
        plot(xx,yy);
    end

    function dd=eval_dists(xx1,yy1,xx2,aa,bb)
        yy2 = bb*((1-(xx2/aa).*(xx2/aa)).^0.5);
        dd = ((xx1-xx2).*(xx1-xx2)+(yy1-yy2).*(yy1-yy2)).^0.5;
    end
end