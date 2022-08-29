function [kn,cnt] = purge_singularity(k)

kn = k;
cnt = 0;

for j = 1 : size(k,2)
    lj = j-1;
    uj = j+1;
    if lj<1
        lj = 1;
    end
    if uj>size(k,2)
        uj = size(k,2);
    end
    
    for i = 1 : size(k,1)
        li = i-1; ri = i+1;
        if li<1
            li = size(k,1);
        end
        if ri>size(k,1)
            ri = 1;
        end
        
        maxi = max([k(li,j), k(ri,j)]');
        if k(i,j)>maxi
            cnt = cnt+1;
            %fprintf('(%d,%d): %d, I-(%d,%d)\n',i,j,k(i,j),k(li,j), k(ri,j));
            kn(i,j) = maxi;
        end
        
        maxj = max([k(i,lj), k(i,uj)]');
        if k(i,j)>maxj
            cnt = cnt+1;
            %fprintf('(%d,%d): %d, J-(%d,%d)\n',i,j,k(i,j),k(i,lj), k(i,uj));
            kn(i,j) = maxj;
        end
    end
end

fprintf('In total %d points purged\n',cnt);
