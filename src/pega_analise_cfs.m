function [ output_args ] = pega_analise_cfs( DATA )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%
% cria e acessa  diretorio de dados
%
cd('DADOS_CI_CC');
mkdir(DATA);
cd(DATA);
%
%  cria dir de CI 
%
mkdir('CI')
cd('CI')
%
% pega a analise do CFS
LINK=strcat('http://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs/cfs.',DATA,'/00/6hrly_grib_01/pgbanl.01.',DATA,'00.grb2');
FILE=strcat('pgbanl.01.',DATA,'00.grb2');
urlwrite(LINK,FILE);

cd('..');
cd('..');
cd('..');

end

