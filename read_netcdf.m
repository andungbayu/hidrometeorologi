% mulai program
clear
clc

% load octave package
pkg load netcdf
pkg load io

% definisi parameter
loop_pos=1;            % posisi dalam loop
max_hujan_tahunan=[];   % variabel kosong utk simpan output 

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
    max_hujan=max(hujan_at_pos);

    % simpan kedalam output variabel
    max_hujan_tahunan(loop_pos)=max_hujan;
    
    % tambah index loop utk iterasi berikutnya
    loop_pos=loop_pos+1; 

% akhiri loop tahun
end

% transpose data
max_hujan_tahunan=max_hujan_tahunan.';

% sort data dari max ke min
max_hujan_tahunan=sortrows(max_hujan_tahunan,-1);


% -------------menghitung hujan kala ulang-----------------%

% buat ranking max hujan tahunan
rank=1:16;

% transpose ranking
rank=rank.';

% hitung exceedance probability
exceedance=rank./(16+1);

% hitung hujan kala ulang
kala_ulang=1./exceedance;

% interpolasi kala ulang
periode_tahun(:,1)=2:15;
kala_ulang_intrp=interp1(kala_ulang,max_hujan_tahunan,periode_tahun);

% copy untuk export
output(:,1)=periode_tahun;
output(:,2)=kala_ulang_intrp;

% export ke csv
dlmwrite('kala_ulang.csv',output);

