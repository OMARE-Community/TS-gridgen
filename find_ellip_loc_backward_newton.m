function [xi,yi,yo,angles] = find_ellip_loc_backward_newton(ao,bo,co,ai,bi,ci,xo,varargin)

ITER_COUNT_MAX = 10000;
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
    %[cxs,~] = line_ellipse_intersection(xo,yo,ci*ones(size(xo)),zeros(size(xo)),ai,bi,ci);
    [cxs,~] = find_ellip_loc_backward(ao,bo,co,ai,bi,ci,xo,varargin{:});
    
    cxs = cxs - ci;   % Relative to the ellipse center
    
    a4s = (ai^2-bi^2)^2*ones(size(xo));
    a3s = -2*ai^2*(ai^2-bi^2)*xo;
    a2s = ai*ai*(ai*ai*(xo.*xo)+bi*bi*(yo.*yo)-a4s);
    a1s = 2*(ai^4)*(ai*ai-bi*bi)*xo;
    a0s = -(ai^6)*(xo.*xo);
    
    iter_count = 0;
    while iter_count < ITER_COUNT_MAX
        iter_count = iter_count + 1;
        
        [fvals,fdvals] = eval_F_FD(a4s,a3s,a2s,a1s,a0s,cxs);
        
        if numel(find(abs(fvals)>EPS)) == 0
            fprintf('Iteration used: %d\n',iter_count);
            break;
        end
        
        cxs = cxs - (fvals./fdvals)/10;
        cxs(cxs> ai) =  ai-1e-16;
        cxs(cxs<-ai) = -ai+1e-16;
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

    function [FVAL,FDVAL]=eval_F_FD(a4s,a3s,a2s,a1s,a0s,xs)
        FVAL  =   a4s.*(xs.^4)+  a3s.*(xs.^3)+  a2s.*(xs.^2)+a1s.*xs+a0s;
        FDVAL = 4*a4s.*(xs.^3)+3*a3s.*(xs.^2)+2*a2s.*xs     +a1s;
    end
end