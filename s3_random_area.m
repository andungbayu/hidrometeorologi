% memulai program
clear
clc

% load netcdf & statistics package
pkg load netcdf
pkg load statistics

% --------------------pemrosesan data hujan---------------------------

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

% ---------------------pemrosesan topografi------------------------
  
% buka data etopo
load('elevasi.mat');
  
% mendapatkan ukuran latlon
nlat=length(ilat);
nlon=length(ilon);

% menentukan jumlah lokasi sample
npos=200;
pos=1;

% mendapatkan posisi tiap lokasi
while (pos<=npos)

    % menentukan koordinat random
    randlat=ceil(rand*nlat);
    randlon=ceil(rand*nlon);
    poslat(pos)=(ilat(randlat));
    poslon(pos)=(ilon(randlon));

    % menentukan elevasi
    elev(pos)=height(randlat,randlon);

    % tambah posisi jika lokasi adalah daratan
    if elev(pos)>=0,pos=pos+1;end
end

% plot data
clf;
image(mlon_rain,mlat_rain,height);
hold on
plot(poslon,poslat,'x')

% simpan posisi
savename='station.mat';
save(savename,'poslat','poslon','elev');
