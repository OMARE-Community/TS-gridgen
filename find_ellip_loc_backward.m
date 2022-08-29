function [xi,yi,yo,angles] = find_ellip_loc_backward(ao,bo,co,ai,bi,ci,xo,varargin)

PLOT = 0;
if numel(varargin) > 0
    PLOT = varargin{1};
end

%% 
MITF = 0;
WS = NaN;
if numel(varargin) > 1
    MITF = 1;
    WS = varargin{2};
end

%% Special case of innermost ellipse
if bi == 0
    [xi,yi,yo,angles] = find_ellip_loc(ao,bo,co,ai,bi,ci,xo,PLOT);
    
else
    %%
    yo = -bo*sqrt(1-(xo-co).*(xo-co)/(ao*ao));
    ofsti = (ai*ai-bi*bi)^0.5;

    %%
    [p1xs,p1ys] = line_ellipse_intersection(xo,yo,(ci-ofsti)*ones(size(xo)),zeros(size(xo)),ai,bi,ci);
    [p2xs,p2ys] = line_ellipse_intersection(xo,yo,(ci+ofsti)*ones(size(xo)),zeros(size(xo)),ai,bi,ci);
    [crsxs,crsys] = line_intersection( ...
        p1xs,p1ys,(ci+ofsti)*ones(size(xo)),zeros(size(xo)), ...
        p2xs,p2ys,(ci-ofsti)*ones(size(xo)),zeros(size(xo)) );
    [xi,yi] = line_ellipse_intersection(xo,yo,crsxs,crsys,ai,bi,ci);

    %%
    xi( (yo==0) & (xo<co)) = ci-ai;
    xi( (yo==0) & (xo>co)) = ci+ai;
    yi( (yo==0) ) = 0;

    %% 
    if MITF == 1
        [xmiti,ymiti] = line_ellipse_intersection(xo,yo,ci*ones(size(xo)),zeros(size(xo)),ai,bi,ci);
        xi = xi .* (1-WS) + xmiti .* WS;
        yi = -bi*sqrt(1-((xi-ci)/ai).^2);
        
        %xi = xmiti;  yi = ymiti;
    end
    
    %%
    xi = real(xi);
    yi = real(yi);
    
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
end