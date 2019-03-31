% memulai program
clear
clc

% load netcdf & statistics package
pkg load netcdf

% ------------------load sample data hujan--------------------

% buka file per tahun
for nyear=2003:2003, %2018,

% tampilkan progress
disp(['membuka file tahun',num2str(nyear)]);

% definisi nama file netcdf
ncfile=['CCS_2019-03-24115920pm_',num2str(nyear),'.nc'];

% membuka file netcdf
data=ncread(ncfile,'precip');
lat=ncread(ncfile,'lat');
lon=ncread(ncfile,'lon');

% membuat latlon utk resolusi baru
ilat=lat(1):-0.01:lat(end);
ilon=lon(1):0.01:lon(end);

% akhiri loop nyear
end

% ------------------- load data topografi ------------------------  

% definisi file topografi
topofile='etopo1.nc';

% membuat rentang latlon
lat_etopo=ncread(topofile,'lat');
lon_etopo=ncread(topofile,'lon');
topo=ncread(topofile,'Band1');

% transpose topografi
topo=topo.';

% membuat meshgrid data topo dan hujan
[mlon_etopo,mlat_etopo]=meshgrid(lon_etopo,lat_etopo);
[mlon_rain,mlat_rain]=meshgrid(ilon,ilat);

% interpolate to rain grid
height=interp2(mlon_etopo,mlat_etopo,topo,mlon_rain,mlat_rain);

% menghilangkan topografi dasar laut
height(height<0)=nan;

% begin plot
clf
image(mlon_rain,mlat_rain,height);

% simpan data
savename='elevasi.mat';
save(savename,'height','mlat_rain','mlon_rain')