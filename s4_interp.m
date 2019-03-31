% mulai program
clear
clc

% load package
pkg load netcdf

%----------------------buka data------------------------

% definisi file
station_pos='station.mat';
rain_data='CCS_2019-03-24115920pm_2003.nc';

% buka data hujan
lat=ncread(rain_data,'lat');
lon=ncread(rain_data,'lon');
hujan=ncread(rain_data,'precip');

% read station coordinate
load('station.mat');

% mendapatkan info jumlah stasiun
nstation=length(poslat);

% buka data satu persatu
for stat=1:nstation

    % hitung beda jarak stasiun dengan grid hujan
    lat_dif=abs(lat-poslat(stat));
    lon_dif=abs(lon-poslon(stat)); 

    % menentukan posisi stasiun dalam grid
    latpos=find(lat_dif==min(lat_dif));
    lonpos=find(lon_dif==min(lon_dif));

    % hitung curah hujan tahunan pada posisi grid
    seri_hujan=squeeze(hujan(lonpos,latpos,:)); 
    hujan_stat(stat)=sum(seri_hujan(:)); 

% akhiri loop stat
end

%-----------------interpolasi--------------------------

% export to csv
csvfile='hujan_stat.csv';
table=[poslon.',poslat.',hujan_stat.'];
dlmwrite(csvfile,table);

% convert data ke SHP via saga-GIS command
system(['saga_cmd shapes_points 0 ',...
    '-POINTS saga_stat ',...
    '-TABLE hujan_stat.csv ',...
    '-X lon -Y lat -Z rain']);

% spline interpolation melalui saga-gis command
system(['saga_cmd grid_spline 6 ',...
    '-SHAPES saga_stat.shp -FIELD rain -TARGET_DEFINITION 0 ',...
    '-TARGET_USER_XMIN 108.40 -TARGET_USER_XMAX 110.83 ',...
    '-TARGET_USER_YMIN -8.43 -TARGET_USER_YMAX -6.2 ',...
    '-TARGET_USER_SIZE 0.01 -TARGET_OUT_GRID saga_spline']);

% convert data ke netcdf via GDAL    
system(['saga_cmd io_gdal 1 ',...
    '-GRIDS saga_spline.sgrd -FILE octave_spline.nc ',...
    '-FORMAT 13 -SET_NODATA 1 -NODATA -999']);

% membuka data interpolasi
interp_data=ncread('octave_spline.nc','Band1');
interp_lat=ncread('octave_spline.nc','lat');
interp_lon=ncread('octave_spline.nc','lon');

% membuat meshgrid untuk data hasil interpolasi
[mesh_ilon,mesh_ilat]=meshgrid(interp_lon,interp_lat);

% membuat latlon sesuai koordinat dan resolusi grid data hujan
rain_lat=lat(1):-0.01:lat(end);
rain_lon=lon(1):0.01:lon(end);

% membuat meshgrid untuk resolusi grid data hujan
[mesh_rlon,mesh_rlat]=meshgrid(rain_lon,rain_lat);

% menyesuaikan koordinat lokasi grid hujan 
interp_spline=interp2(mesh_ilon,mesh_ilat,interp_data.',mesh_rlon,mesh_rlat);

% --------------plot hasil interpolasi--------------------

% load data elevasi
load('elevasi.mat');

% menghapus interpolasi pada lautan
interp_spline(isnan(height))=nan;

% plot data asli
clf
subplot(2,1,1)
m_proj('mercator','lon',[min(rain_lon),max(rain_lon)],...
   'lat',[min(rain_lat),max(rain_lat)]);
m_pcolor(lon,lat,(sum(hujan,3)).');
m_coast
m_grid

% plot hasil interpolasi
subplot(2,1,2)
m_proj('mercator','lon',[min(rain_lon),max(rain_lon)],...
   'lat',[min(rain_lat),max(rain_lat)]);
m_pcolor(rain_lon,rain_lat,interp_spline);
m_grid





