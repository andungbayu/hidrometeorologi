% buat pprogram baru
clear
clc

% load octave package
pkg load netcdf
pkg load io

% definisi parameter
loop_pos=1;           % posisi dalam loop
max_hujan_tahunan=[]; % variabel kosong utk simpan output

% loop data pertahun
for tahun=2003:2018,

    % definisi data hujan pertahun
    file_netcdf=['CCS_2019-02-26060711pm_',num2str(tahun),'.nc'];
    disp(file_netcdf)

    % buka data
    lat=ncread(file_netcdf,'lat');
    lon=ncread(file_netcdf,'lon');
    precip=ncread(file_netcdf,'precip');

    % konvert precip dari integer ke double
    precip=double(precip);

    % definisi lat dan lon index untuk data stasiun
    lat_idx=8;     % -7.76 derajat LS
    lon_idx=7;     % 110.20 derajat BT

    % ambil data pada koordinat indeks
    hujan_at_pos=precip(lon_idx,lat_idx,:);
    max_hujan=max(hujan_at_pos); 

    % simpan hujan max kedalam time series
    max_hujan_tahunan(loop_pos)=max_hujan;

    % tambah index baris untuk iterasi tahun selanjutnya
    loop_pos=loop_pos+1;

% Akhiri loop tahun
end

%---------------menghitung hujan kala ulang----------------------%

% transpose hujan maksimum tahunan
max_hujan_tahunan=max_hujan_tahunan.';

% urutkan data dari max ke min
max_hujan_tahunan=sortrows(max_hujan_tahunan,-1);

% buat ranking max hujan tahunan
rank(:,1)=1:16;

% hitung exceedance probability
exceedance=rank./(16+1);

% hitung kala ulang hujan
kala_ulang=1./exceedance;

% interpolasi 1D untuk pembulatan data
periode_tahun_dicari(:,1)=2:15;
kala_ulang_bulat=interp1(kala_ulang,max_hujan_tahunan,periode_tahun_dicari);

% copy data untuk export
output(:,1)=periode_tahun_dicari;
output(:,2)=kala_ulang_bulat;

% mulai export data ke csv
dlmwrite('kala_ulang_7.76_110.20.csv',output);

















