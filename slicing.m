function [slats,slons] = slicing(lats,lons)

OPT = 1;

xsize = size(lats,1)-1;
ysize = size(lats,2)-1;

xstt = xsize/4+1;
xstp = xstt + xsize/2;

ystt = round(ysize*3/4);
ystp = round(ysize*4/5);
ystp = ystt + 1;

ystt = ysize;
ystp = ysize + 1;

slats = lats(xstt:xstp,[ystt,ystp]);
slons = lons(xstt:xstp,[ystt,ystp]);

if OPT == 1
    slats = [ slats(:,1); slats(size(slats,1):-1:1,2) ];
    slons = [ slons(:,1); slons(size(slons,1):-1:1,2) ];
end

end