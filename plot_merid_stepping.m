function plot_merid_stepping(lats,varargin)

SCAL = 1.0;
if numel(varargin) > 0
    SCAL = varargin{1};
end

figure;
N = size(lats,1)-1;
plot(lats(1:N,1),(lats(2:N+1,1)-lats(1:N,1))/(180*SCAL)*pi*6371,'-*');
grid on;
xlabel('Latitide');
ylabel('Meridional Distance (km)');

end