function kmt = locate_pop_kmt(z,config)

if config == 60
    ds = load('~/MATLAB/GridGen/CESM/gx1v6_vert_grid');
    ds = [ 0; ds(:,2); 1e10 ];
end

kmt = zeros(size(z));
for k = 1 : numel(ds)-1
    %[rr,cc] = find((z>ds(k-1))&(z<=ds(k)));
    %kmt(rr,cc) = k-1;
    kmt((z<-ds(k))&(z>-ds(k+1))) = k-1;
end

while 1 == 1
    [kmt,cnt] = purge_singularity(kmt);
    if cnt == 0
        break;
    end
end

end