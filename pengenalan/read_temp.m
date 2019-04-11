% memulai program
clear
clc

%load netcdf packages untuk membuka file .nc
pkg load netcdf

% menentukan nama file yang akan dibuka
namafile='air.2018.nc';

% mendapatkan info variabel netcdf
getinfo=ncinfo(namafile);

% mendapatkan variable koordinat
lat=ncread(namafile,'lat');
lon=ncread(namafile,'lon');

% mendapatkan variable waktu
time=ncread(namafile,'time');

% mendapatkan variable level tekanan udara
level=ncread(namafile,'level');


%-------------- analisis time series -------------------

% definisi posisi koordinat yang ingin dibaca
getlat=-10;    % 10 derajat LS
getlon=110;    % 110 derajat BT

% temukan indeks urutan posisi dari ...
% variabel koordinat 'lat' & 'lon' yang sebelumnya dibaca
lat_idx=find(lat==getlat);
lon_idx=find(lon==getlon);

% definisi level tekanan udara
getlevel=850;   % level tekanan udara dekat permukaan (850 hPa)

% temukan indeks urutan posisi dari ...
% variabel 'level' yang sebelumnya dibaca
lev_idx=find(level==getlevel);

% mendapatkan data temperatur berdasar indeks posisi
start=[lon_idx,lat_idx,lev_idx,1];   % angka 1 menunjukan awal waktu
count=[1,1,1,365];                   % angka 365 menunjukan panjang data 365 hari
series_temp=ncread(namafile,'air',start,count); 

% ubah data menjadi 1 dimensi
series_temp=squeeze(series_temp);


% ----------- plot data time series ------------------   

% menampilkan halaman plot
graphics_toolkit('gnuplot')
figure

% plot data temperatur
plot(series_temp)

% menampilkan label
xlabel('hari ke-')
ylabel('temperatur [K]')

% menampilkan judul
title('Temperatur Harian Tahun 2018')

% menentukan batas axis
xlim([1,365])
ylim([280,295])

% simpan sebagai png
print -dpng temp_series.png
