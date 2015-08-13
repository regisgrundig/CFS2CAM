%MATLAB
%
%  CFS2CAM versão 3.0 
%
%
% 28/02/2015 By regis
%
% Modificação geral do codigo. Mais harmonioso.
% 01/01/2015 -  rescrever mais clean o codigo para tratamento de CI
%               incluir PHIS e TBOT como CI do CFS no CAM 
%               Ajustar TS (tinha alguma coisa errada)
% 02/02/2015 - Criar plot de mapas com mapas mundi 
%              Controlar lotagem dos mapas 
%              Controlar escala de legenda (para ficarem iguais a plotagem
%              do CAM e do CFS
% 03/02/2015 - incluir o adquire_dados com funcao. retirar os now() e por a
%              data do dia da aquisição. (a fazer)
%              Verificar no saidaCAM como estao as variaveis (a fazer)
%              Testar todas as variaveis campos (a fazer)
%              Iniciar processo de SST 
clear all;
close all;
clf;

%
% CONFIGURACAO
%
calendar(today);
tmp=datestr(today,30);
prompt=strcat('Data da Rodada (YYYYMMDD) ou enter para data de hoje (',tmp(1:8),'):');
DATA=input(prompt,'s');
if isempty(DATA)
   DATA=tmp(1:8) ;  
end    
%%% informe a data da rodada
%DATA=;            %%% use esa forma se quiser rodar na data de hoje
%
% ESSA DATA E NO ESTILO 
% 01/09/2010 
% DATA_DA_RODADA=901;
% DATA_DA_RODADA=str2num(DATA);

%
% chama a rotina que trata da analise do arquivo CFS
%  extrai as variaveis obrigatórias para o CAM
%  
cfs2cam_analise(DATA);
cfs2cam_sst(DATA);



