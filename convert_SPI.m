% mulai program
clear
clc

% load octave package
pkg load netcdf
pkg load io
pkg load statistics

% definisi output variabel
series_hujan=[];      % variabel kosong utk output

% loop data pertahun
for tahun=2003:2018

    % definisi  data hujan pertahun 
    file_netcdf=['CCS_2019-02-26060711pm_',num2str(tahun),'.nc'];
    disp(file_netcdf);

    % buka data
    lat=ncread(file_netcdf,'lat');
    lon=ncread(file_netcdf,'lon');
    precip=ncread(file_netcdf,'precip');

    % konvert precip dari integer ke double
    precip=double(precip);

    % definisi lat lon index utk stasiun
    lat_idx=8;
    lon_idx=7;

    % ambil data pada index koordinat
    hujan_at_pos=precip(lon_idx,lat_idx,:);
   
    %-----------------menghitung hujan bulanan------------------%

    % definisi parameter
    loop_pos=1;                     % posisi dalam loop
    hujan_bulanan=zeros(12,1);      % variabel kosong utk hujan bulanan  

    % definisi awal dan akhir data
    tanggal_awal=datenum(tahun,1,1);
    tanggal_akhir=datenum(tahun,12,31);
    rentang_tanggal=[tanggal_awal:tanggal_akhir];
    
    % loop ke tiap tanggal
    for tanggal_ke=1:length(hujan_at_pos); 

        % mendapat informasi bulan
        tanggal=rentang_tanggal(tanggal_ke); 
        vektor_tanggal=datevec(tanggal);
        bulan=vektor_tanggal(2);

        % akumulasi curah hujan bulanan
        hujan_bulanan(bulan)=hujan_bulanan(bulan)+hujan_at_pos(tanggal_ke);
             
    % akhiri loop tanggal
    end

% akumulasi data bulanan
series_hujan=[series_hujan;hujan_bulanan];
series_hujan(series_hujan<0)=0;

% export output
dlmwrite('precip.txt',series_hujan);

% akhiri loop tahun
end

