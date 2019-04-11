% memulai program
clc
clear

% load netcdf package
pkg load netcdf

% deskripsi nama file
dl_file='dlwrf.sfc.gauss.2018.nc';
ds_file='dswrf.sfc.gauss.2018.nc';
ul_file='ulwrf.sfc.gauss.2018.nc';
us_file='uswrf.sfc.gauss.2018.nc';

% membuka info data radiasi
dl_info=ncinfo(dl_file);
ds_info=ncinfo(ds_file);
ul_info=ncinfo(ul_file);
us_info=ncinfo(us_file);

% cek variabel
disp('variabel downward longwave')
dl_info.Variables.Name
disp('variabel downward shortwave')
ds_info.Variables.Name
disp('variable upward longwave')
ul_info.Variables.Name
disp('variable upward shortwave')
us_info.Variables.Name

% !!!!!!!!SAMPAI DISINI JALANKAN SCRIPT!!!!!!!!! 
% !!!!!UNTUK MENGETAHUI NAMA VARIABLE!!!!!!!!!!!!!

%-----------------------------------------------

% dari menjalankan program diatas kita tahu data
% yang diambil bernama dlwrf, dswrf, ulwrf, dan uswrf

% buka data
dlwrf=ncread(dl_file,'dlwrf');
ulwrf=ncread(ul_file,'ulwrf');
dswrf=ncread(ds_file,'dswrf');
uswrf=ncread(us_file,'uswrf');

% menghitung longwave radiation budget
net_lw=dlwrf-ulwrf;
net_sw=dswrf-uswrf;

% menghitung net radiation budget
net_radiation=net_sw+net_lw;

% !!!!!!!!!!!!!PROSES PERHITUNGAN RADIASI SELESAI!!!!!!!!


%--------------------------------------------------------
% !!!!!!!!!!!!!!!!!!!!MULAI PLOT DATA!!!!!!!!!!!!!!!!!!!!


% buka variabel lain (lat,lon,time) dari salah satu file
lat=ncread(dl_file,'lat');
lon=ncread(dl_file,'lon');
time=ncread(dl_file,'time');

% definisi lokasi yang di plot
plot_lat=-10;
plot_lon=110;

% menemukan indeks posisi berdasar lat-lon array
% fungsi abs=menghitung nilai mutlak
% fungsi min=menghitung nilai minimum
idx_lat=find(abs(lat-plot_lat)==min(abs(lat-plot_lat)));
idx_lon=find(abs(lon-plot_lon)==min(abs(lon-plot_lon)));

% mendapatkan seri data
% fungsi double: konversi bit dari integer ke double
% fungsi squeeze: konversi 3D matrix menjadi 1D array
seri_lw=double(squeeze(net_lw(idx_lon,idx_lat,:)));
seri_sw=double(squeeze(net_sw(idx_lon,idx_lat,:)));
seri_net=double(squeeze(net_radiation(idx_lon,idx_lat,:)));

% memulai  plot data series
clf                  % membersihkan layar plot dari plot sebelumnya 
plot(seri_net,'-b')  % plot data series, -g: garis biru
hold on              % aktifkan plot overlay
plot(seri_sw,'-r')   % plot data kedua utk overlay, -r: garis merah 
plot(seri_lw,'-g')   % plot data ketiga utk overlay -b: garis hijau

% menampilkan legenda sesuai dengan urutan plot
legend('net radiation','net shortwave','net longwave')

% menampilkan axis label
xlabel('hari ke-')
ylabel('Imbangan radiasi [W/m^2]')

% menampilkan judul
title('Imbangan Radiasi Tahun 2018')

% menentukan batas axis
xlim([1,365])

%!!!!!!!!!!!!!!! JALANKAN SCRIPT UNTUK MELIHAT HASIL PLOT !!!!!!!!!!!


% ---------------------------------------------------------------------
%!!!!!!!!!!!!!!!!! MEMBUAT PLOT DALAM BENTUK PETA !!!!!!!!!!!!!!!!!!!

% tentukan hari keberapa dari tahun tsb yang akan diplot
% misal saat net radiation minimum/maximum
hari_ke=140;

% ambil data spasial pada hari ke 90
net_map=net_radiation(:,:,hari_ke);

% konversi bit dan dimensi utk plot
% fungsi .' digunakan untuk transpose
net_map=(double(squeeze(net_map))).';

% load mapping package ke sistem path
% pastikan folder m_map ada dalam 1 folder
addpath(genpath('m_map'))

% aktifkan  QT graphic toolkit
% graphics_toolkit('qt')
 
% menampilkan halaman plot baru
figure

% membuat latlon meshgrid
[X,Y]=meshgrid(lon,lat);

% definisi map projection
m_proj('Robinson','lon',[0,360]);

% plot temperatur
m_pcolor(X,Y,net_map);

% plot garis pantai
m_coast;

% plot garis lintang dan bujur
m_grid('xtick',[-180,-90,0,90,180],'ytick',[-90,-50,0,50,90],...
'xticklabels',[],'yticklabels',['90^oS';'50^oS';'0^o';'50^oN';'90^oN'],...
'linewidth',1);

% tambahkan label
colorbar

% tambahkan judul
title('Imbangan Radiasi Tanggal 31 Maret 2018 [W/m^2]')
