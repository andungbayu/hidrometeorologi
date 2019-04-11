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

%-------------- analisis spasial -------------------

% definisi level tekanan udara
getlevel=850;  % 850 hPa   
lev_idx=find(level==getlevel);

% definisi waktu yang akan diplot
time_idx=1;   % 1 januari 2018

% mendapatkan data temperatur berdasar indeks posisi
start=[1,1,lev_idx,time_idx];   % angka 1 menunjukan awal pembacaan data
count=[144,73,1,1];             % angka 144 & 73 berdasarkan getinfo.Variable.Size
spatial_temp=ncread(namafile,'air',start,count); 



%-------------- plot data spasial -------------------

% load mapping package to path
addpath(genpath('m_map'))

% aktifkan  QT graphic toolkit
graphics_toolkit('qt')
 
% menampilkan halaman plot
figure

% konversi data ke double dan transpose
spatial_temp=double(spatial_temp.'); 

% membuat latlon meshgrid
[X,Y]=meshgrid(lon,lat);

% definisi map projection
m_proj('Robinson','lon',[0,360]);

% plot temperatur
m_pcolor(X,Y,spatial_temp);

% plot garis pantai
m_coast;

% plot garis lintang dan bujur
m_grid('xtick',[-180,-90,0,90,180],'ytick',[-90,-50,0,50,90],...
'xticklabels',[],'yticklabels',['90^oS';'50^oS';'0^o';'50^oN';'90^oN'],...
'linewidth',1);

% tambahkan label
colorbar

% tambahkan judul
title('Temperatur Udara Tanggal 1 Januari 2018 [K]')