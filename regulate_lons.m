function [rlons,rlats] = regulate_lons( lons, lats, varargin )

if numel(varargin) == 0  % Regulate due to longitude changes
    flg = 0;
    if lons(1) < -90;
        flg = -1;
    end
    flg = 2;  % temporary
    
    cnt = 1;
    rlons = struct('vals',[]);
    rlats = struct('vals',[]);
    for ii = 1 : numel(lons)
        if lons(ii) < -90 && flg == 0
            if lons(ii) == -180;
                rlons(cnt).vals = [ rlons(cnt).vals; 180 ];
                rlats(cnt).vals = [ rlats(cnt).vals; lats(ii) ];
            end
            cnt = cnt + 1;
            rlons(cnt).vals = [ lons(ii) ];
            rlats(cnt).vals = [ lats(ii) ];
            flg = -1;
        elseif lons(ii) > 90 && flg == -1
            if lons(ii) == 180;
                rlons(cnt).vals = [ rlons(cnt).vals; -180 ];
                rlats(cnt).vals = [ rlats(cnt).vals; lats(ii) ];
            end
            cnt = cnt + 1;
            rlons(cnt).vals = [ lons(ii) ];
            rlats(cnt).vals = [ lats(ii) ];
            flg = 0;
        else
           rlons(cnt).vals = [ rlons(cnt).vals; lons(ii) ];
           rlats(cnt).vals = [ rlats(cnt).vals; lats(ii) ];
        end 
    end
    
else  % Regulate due to segments info
    flgs = varargin{1};
    
    rlons = struct('vals',{});
    rlats = struct('vals',{});
    
    segs = zeros(0,2);
    cnt = 0;
    last = 0;
    for i = 1 : numel(flgs)
        if flgs(i) == 0
            if last == 0
                cnt = cnt + 1;
                segs(cnt,:) = [ i, i+1 ];
                last = 1;
            else
                segs(cnt,2) = i + 1;
            end
        else
            last = 0;
        end
    end
    
    ccnt = 0;
    for i = 1 : cnt
        if segs(i,1) < segs(i,2)
            ccnt = ccnt + 1;
            rlons(ccnt).vals = lons(segs(i,1):segs(i,2));
            rlats(ccnt).vals = lats(segs(i,1):segs(i,2));
        end
    end
end

end