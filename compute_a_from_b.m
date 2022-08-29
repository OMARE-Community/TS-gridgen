function a=compute_a_from_b(b,a_thres,varargin)
% COMPUTE_A_FROM_B: compute long axises given short axises and location of
% shifted focal point 
%   a = compute_a_from_b(b,a_thres)
%       b: short axes values, a_thres: shifted location of focal point
%       a: returned value of long axes
%

OPT = 2;

if OPT == 1
    slope = ( 1 - a_thres );
    a = slope * b + a_thres;
elseif OPT == 2
    a2 = a_thres;
    a1 = 1-2*a_thres;
    a0 = a_thres;
    a = a2*(b.*b) + a1*b + a0;
elseif OPT == 3
    EPS = 1e-16;
    
    als = a_thres*ones(size(b));
    ars = ones(size(b));
    ncvgf = ones(size(b));
    
    while nnz(ncvgf) > 0
        fvalsl = eval_FF(a_thres,als);
        fvalsr = eval_FF(a_thres,ars);
        
        a(fvalsl==b) = als(fvalsl==b);
        ncvgf(fvalsl==b) = 0;
        a(fvalsr==b) = ars(fvalsr==b);
        ncvgf(fvalsr==b) = 0;
        
        for i = 1 : numel(b)
            if ncvgf(i) == 1
                ca = (als(i) + ars(i))/2;
                if eval_FF(a_thres,ca) < b(i)-EPS
                    als(i) = ca;
                elseif eval_FF(a_thres,ca) > b(i)+EPS
                    ars(i) = ca;
                else
                    ncvgf(i) = 0;
                    a(i) = ca;
                end
            end
        end
    end
end

if numel(varargin) > 0
    if varargin{1} == 1
        figure; plot(a,b,'-*'); xlim([0 1]); ylim([0 1]); daspect([1 1 1]); hold on;
        grid on; plot([0 1],[0 1],'--k');
        xlabel('a'); ylabel('b');
    end
end

    function yy = eval_FF(alpha,xx)
        yy = (xx-alpha/2) + (alpha/2)*sin((xx-(alpha+1)/2)*pi/(1-alpha));
    end

end