function [ NOME_ARQUIVO_SST_CFS , NOME_ARQUIVO_SKINTEMP_CFS] = pega_sst_cfs( DATA )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%
% cria e acessa  diretorio de dados
%


%
% CRIA AS DATAS DOS ARQUIVOS DE PREVISAO
%
% 
NOME_ARQUIVO_SST_CFS=cell(9,1);
NOME_ARQUIVO_SKINTEMP_CFS=cell(9,1);
for i=0:8
    TMP=datestr(datenum(DATA,'yyyymmdd')+(30*i),30);
    DATA_FUTURO=TMP(1:6);
    NOME_ARQUIVO_SST_CFS{i+1}=strcat('ocnf.01.',DATA,'00.',DATA_FUTURO,'.avrg.grib.grb2');
    NOME_ARQUIVO_SKINTEMP_CFS{i+1}=strcat('pgbf.01.',DATA,'00.',DATA_FUTURO,'.avrg.grib.grb2');

end


cd('DADOS_CI_CC');
mkdir(DATA);
cd(DATA);
% %
% %  cria dir de CI 
% %
mkdir('SST')
cd('SST')
% %
% % pega 
% 
% 
for i=1:9
LINK=strcat('http://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs/cfs.',DATA,'/00/monthly_grib_01/',char(NOME_ARQUIVO_SST_CFS{i}));
if (exist(char(NOME_ARQUIVO_SST_CFS{i}),'file') ==0)
urlwrite(LINK,char(NOME_ARQUIVO_SST_CFS{i}));
end
LINK=strcat('http://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs/cfs.',DATA,'/00/monthly_grib_01/',char(NOME_ARQUIVO_SKINTEMP_CFS{i}));
if (exist(char(NOME_ARQUIVO_SKINTEMP_CFS{i}),'file') ==0)
urlwrite(LINK,char(NOME_ARQUIVO_SKINTEMP_CFS{i}));
end
end





% 
cd('..');
cd('..');
 cd('..');


end

