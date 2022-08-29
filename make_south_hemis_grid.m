function [lats,lons] = make_south_hemis_grid( res_lat, res_lon, start_lat, start_lon, varargin )

PLAN = 4;
% 1 : regular lat-lon
% 2 : polar anisotropy adjusted (square-root sin-lat)
% 3 : Mercator projection
% 4 : Mercator with tapering

MAKE_MATRIX_FLG = 1;

%start_lat = -20.0;
stop_lat  = -78.56;
%stop_lat  = -78.5;   % T01

if PLAN == 1
    lats = [ start_lat : -res_lat : stop_lat ];
    lons = [ 0         :  res_lon : 360.0    ] + start_lon;
elseif PLAN == 2
    lons = [ 0 : res_lon : 360.0 ] + start_lon;
    
    assert(numel(varargin)>=2);
    aniso_thres = varargin{1};
    aniso_turning_lat = varargin{2};
    
    ANISOTROPY_THRES = aniso_thres;
    ANISOTROPY_MAX = 1 / cosd(stop_lat) * res_lat / res_lon;
    PROP = ANISOTROPY_MAX / ANISOTROPY_THRES;
    ANISOTROPY_TURNING_LAT = aniso_turning_lat;
    
    res_lat_last = res_lat;
    if numel(varargin) >= 3
        res_lat_last = varargin{3};
    end
    
    cur_lat = start_lat;
    lats = [ cur_lat ];
    if ANISOTROPY_MAX > ANISOTROPY_THRES
        while cur_lat > ANISOTROPY_TURNING_LAT
            cur_lat_step = translate_cosine( start_lat, ANISOTROPY_TURNING_LAT, res_lat_last, res_lat, cur_lat );
            cur_lat = cur_lat - cur_lat_step;
            lats = [ lats, cur_lat ];
        end

        alpha = (PROP-1) / (stop_lat - cur_lat)^2;
        aniso_lat = cur_lat;
        while cur_lat >= stop_lat
            prop = 1 + alpha * ( cur_lat - aniso_lat ) ^2;
            fprintf('%.3f\n',prop);
            cur_lat = cur_lat - res_lat / prop;
            lats = [ lats, cur_lat ];
        end
    else
        while cur_lat >= stop_lat
            cur_lat_step = translate_cosine( start_lat, stop_lat, res_lat_last, res_lat, cur_lat );
            cur_lat = cur_lat - cur_lat_step;
            lats = [ lats, cur_lat ];
        end
    end
elseif PLAN == 3
    clat = 0;
    lats = zeros(0,1);
    while clat > stop_lat
        cstep = res_lat / secd(clat);
        clat = clat - cstep;
        lats = [ lats; clat ];
    end
    lats = lats';
    
    lons = [ 0 : res_lon : 360 ] + start_lon;
elseif PLAN == 4
    clat = 0;
    lats = zeros(0,1);
    while clat > stop_lat
        if clat > -10
            cstep = res_lat / secd(clat);
        else
            cstep = res_lat / secd( clat / ((clat/(-10))^0.04) );
        end
        clat = clat - cstep;
        lats = [ lats; clat ];
    end
    lats = lats';
    
    lons = [ 0 : res_lon : 360 ] + start_lon;
end
    
lats = fliplr(lats);

if MAKE_MATRIX_FLG == 1
    glats = zeros(numel(lons),numel(lats));
    glons = zeros(numel(lons),numel(lats));

    for i = 1 : numel(lons)
            glats(i,:) = lats';
    end
    for i = 1 : numel(lats)
            glons(:,i) = lons;
    end

    lats = glats;
    lons = glons;
end

    function y = translate_cosine( sttx, stpx, stty, stpy, x )
        x = pi * (x - sttx) / (stpx - sttx);
        y = ( 1 - cos(x) ) / 2;
        y = y * (stpy - stty) + stty;
    end

end