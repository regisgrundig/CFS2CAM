function [ NOME_ARQUIVO_SST_OBS ] = pega_tsm_observada(DATA )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

%¨pega TSM OBSERVADA
%
mkdir('TSM_OBSERVADA');
cd('TSM_OBSERVADA');
mkdir('OISSTV2');
cd('OISSTV2');
SITE='ftp://ftp.emc.ncep.noaa.gov/cmb/sst/oimonth_v2/GRIB/';

NOME_ARQUIVO_SST_OBS=cell(12,1);
for i=12:-1:1
    TMP=datestr(datenum(DATA,'yyyymmdd')-(30*i),30);
    DATA_FUTURO=TMP(1:6);
    NOME_ARQUIVO_SST_OBS{i}=strcat('oiv2mon.',DATA_FUTURO,'.grb');
    
end

for i=1:12
    
    if (exist(NOME_ARQUIVO_SST_OBS{i},'file')==0) 
       LINK=strcat(SITE,char(NOME_ARQUIVO_SST_OBS{i}));
       urlwrite(LINK,char(NOME_ARQUIVO_SST_OBS{i}));
    end
end


cd('..');
cd('..');


end


