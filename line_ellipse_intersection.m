function [xs,ys]=line_ellipse_intersection(x1s,y1s,x2s,y2s,a,b,d)

EPS=1e-14;

%% Params for quadrature
M = (y2s-y1s)./(x2s-x1s);
N = y1s - M.*x1s;

P = (x2s-x1s)./(y2s-y1s);
Q = x1s - P.*y1s;

%% Benign cases
DET = (a^2)*(b^2)*((a^2)*(M.^2)+b^2-(M*d+N).^2);

xls = ( -(M.*N*(a^2)-(b^2)*d) - DET.^0.5 )./(b^2+(a^2)*(M.^2));
xrs = ( -(M.*N*(a^2)-(b^2)*d) + DET.^0.5 )./(b^2+(a^2)*(M.^2));

xs = zeros(size(x1s));

xs( x1s>x2s ) = xrs( x1s>x2s );
xs( x1s<x2s ) = xls( x1s<x2s );

ys = -b*(1-((xs-d).^2)/(a^2)).^0.5;

return

%% Ill cases

DET = (a^2)*(b^2)*((a^2)+(b^2)*(P.^2)-(Q-d).^2);

eys = (-(b^2)*P.*(Q-d)-DET.^0.5)./(a^2+(b^2)*(P.^2));
exs = a*(1-(eys.^2)/(a^2)).^0.5+d;

ys(abs(x2s-x1s)<EPS)=eys(abs(x2s-x1s)<EPS);
xs(abs(x2s-x1s)<EPS)=exs(abs(x2s-x1s)<EPS);

end
