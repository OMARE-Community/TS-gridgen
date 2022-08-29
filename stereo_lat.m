function ret = stereo_lat(lat)
% STEREO_LAT: computes the radius at certain latitude (degree)
%    radius = stereo_lat(lat)

ret = tand((90-lat)/2);

end