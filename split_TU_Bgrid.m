function [MT,NT,MU,NU,tlats,tlons,ulats,ulons]=split_TU_Bgrid(lats,lons)

M = size(lats,1);
N = size(lats,2);

assert(floor(M/2)*2<M);
assert(floor(N/2)*2<N);

MT = floor(M/2);
NT = floor(N/2);

MU = MT + 1;
NU = NT + 1;

tlats = lats(2:2:M,2:2:N);
tlons = lons(2:2:M,2:2:N);

ulats = lats(1:2:M,1:2:N);
ulons = lons(1:2:M,1:2:N);

end