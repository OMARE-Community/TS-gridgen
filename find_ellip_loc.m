function [xi,yi,yo,angles] = find_ellip_loc(ao,bo,co,ai,bi,ci,xo,varargin)

PLOT = 0;
if numel(varargin) > 0
    PLOT = varargin{1};
end

EPS = 1e-6;

%%
yo = -bo*sqrt(1-(xo-co).*(xo-co)/(ao*ao));
iyo = imag(yo);
if nnz(iyo) > 0
    fprintf('Some unreal ys\n');
    [r,c,v]=find(iyo)
end
yo = real(yo);   % temporary fix

slopeN =  yo*ao*ao./((xo-co)*bo*bo);
slopeT = -(xo-co)*bo*bo./(yo*ao*ao);

%u = -(bo*bo*bo/(ao*ao*ao))*sqrt(ao*ao-(xo-co).*(xo-co))./(xo-co);
%v = bo*sqrt(ao*ao-(xo-co).*(xo-co)).*(ao*ao*co-(ao*ao-bo*bo)*xo)./(ao*ao*ao*(xo-co));
u = -(ao./(bo*(xo-co))).*sqrt(ao*ao-(xo-co).*(xo-co));
v = sqrt(ao*ao-(xo-co).*(xo-co)).*(xo*ao./(bo*(xo-co))-bo/ao);

p = 1./u;
q = -v./u;

A = p.*p*bi*bi+ai*ai;
B = 2*p.*(q-ci)*bi*bi;
C = ((q-ci).*(q-ci)-ai*ai)*bi*bi;

B2M4AC = (B.*B-4*A.*C);
yi1 = (-B+sqrt(B2M4AC))./(2*A);
yi2 = (-B-sqrt(B2M4AC))./(2*A);

%yi1(B2M4AC<0) = NaN;
%yi2(B2M4AC<0) = NaN;
yi1(B2M4AC<0) = 0;
yi2(B2M4AC<0) = 0;

xi1 = p.*yi1+q;
xi2 = p.*yi2+q;
%xi1(B2M4AC<0) = ai+ci;  
%xi2(B2M4AC<0) = ai+ci;  

yi = yi2;
xi = xi2;

angles = -angle(complex(xi,yi))+atan(slopeT)-pi/2;
if nnz(abs(imag(angles))>0) > 0
    fprintf('ERROR!\n');
end

[rr,cc] = find(abs(xo-co)<EPS);
for i = 1 : numel(cc)
    xi(rr(i),cc(i)) = xo(rr(i),cc(i));
    yii = -bi*sqrt(1-(xo(rr(i),cc(i))-ci)*(xo(rr(i),cc(i))-ci)/(ai*ai));
    yi(rr(i),cc(i)) = yii;
    angles(rr(i),cc(i)) = 0;
end

[rr,cc] = find(abs(yo)<EPS);
for i = 1 : numel(cc)
    yi(rr(i),cc(i)) = 0;
    xiioffset = ai*sqrt(1-yi(rr(i),cc(i))*yi(rr(i),cc(i))/(bi*bi));
    if xo(rr(i),cc(i)) < co
        xi(rr(i),cc(i)) = ci - xiioffset;
    else
        xi(rr(i),cc(i)) = ci + xiioffset;
    end
    angles(rr(i),cc(i)) = 0;
end

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