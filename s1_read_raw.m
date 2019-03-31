% memulai program
clear
clc

% load netcdf package
pkg load netcdf

% buka file per tahun
for nyear=2003:2018,

% tampilkan progress
disp(['membuka file tahun',num2str(nyear)]);

% definisi nama file netcdf
ncfile=['CCS_2019-03-24115920pm_',num2str(nyear),'.nc'];

% membuka file netcdf
data=ncread(ncfile,'precip');
lat=ncread(ncfile,'lat');
lon=ncread(ncfile,'lon');

% membuat meshgrid untuk resolusi asli
[mlon,mlat]=meshgrid(lon,lat);

% membuat latlon utk resolusi baru
ilat=lat(1):-0.01:lat(end);
ilon=lon(1):0.01:lon(end);

% membuat meshgrid untuk resolusi baru
[mesh_ilon,mesh_ilat]=meshgrid(ilon,ilat);

% buka data per hari
  for t=1:size(data,3),
    
    % ambil data harian dan transpose
    rain=data(:,:,1);
    rain=double(rain.');  % transpose
    
    % interpolasi data
    rain_interp=interp2(mlon,mlat,rain,mesh_ilon,mesh_ilat,'spline');

    % simpan hasil interpolasi
    precip(:,:,t)=rain_interp;

% akhiri loop t
  end

% % plot data
% clf;
% subplot(2,1,1);
% image(mlon,mlat,rain);
% subplot(2,1,2);
% image(mesh_ilon,mesh_ilat,rain_interp);

% definisi output file
outfile=['persiann_ccs_',num2str(nyear),'.mat'];

% simpan file
save(outfile,'precip','ilat','ilon');

% akhiri loop nyear
end