% memulai program
clc
clear

% load netcdf package
pkg load netcdf 

% definisi data temperatur
ncfile='air.2m.gauss.2018.nc';

% dapatkan info file
nc=ncinfo(ncfile);
disp('variabel:')
nc.Variables.Name
disp('dimensi:')
nc.Variables.Size

% buka data
lat=ncread(ncfile,'lat');
lon=ncread(ncfile,'lon');
suhu=ncread(ncfile,'air');

% ambil data suhu hari ke 31 untuk diplot 
plot_suhu=suhu(:,:,31);

% ubah suhu ke celcius
plot_suhu=plot_suhu-273;

%transpose plot
plot_suhu=plot_suhu.';

%-------------- plot data spasial -------------------

% load mapping package to path
addpath(genpath('m_map'))

% membuat latlon meshgrid
[X,Y]=meshgrid(lon,lat);

% definisi map projection
m_proj('Robinson','lon',[0,360]);

% plot temperatur
m_pcolor(X,Y,plot_suhu);

% plot garis pantai
m_coast;

% plot garis lintang dan bujur
m_grid('xtick',[-180,-90,0,90,180],'ytick',[-90,-50,0,50,90],...
'xticklabels',[],'yticklabels',['90^oS';'50^oS';'0^o';'50^oN';'90^oN'],...
'linewidth',1);

% tambahkan label
colorbar

% tambahkan judul
title('Temperatur Udara Tanggal 1 Januari 2018 [^oC]')
