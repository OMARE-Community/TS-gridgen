function [xs,ys]=line_intersection(x1s,y1s,x2s,y2s,x3s,y3s,x4s,y4s)

bott = (x1s-x2s).*(y3s-y4s) -(y1s-y2s).*(x3s-x4s);
xs = (x1s.*y2s-y1s.*x2s).*(x3s-x4s)-(x1s-x2s).*(x3s.*y4s-y3s.*x4s);
ys = (x1s.*y2s-y1s.*x2s).*(y3s-y4s)-(y1s-y2s).*(x3s.*y4s-y3s.*x4s);

xs = xs ./ bott;
ys = ys ./ bott;

end