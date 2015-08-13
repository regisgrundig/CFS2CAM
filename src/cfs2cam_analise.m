function cfs2cam_analise( DATA )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%
% adquire dados
%
opcao=input('Baixar os dados de análise do CFS (S/N)?','s');
if (isempty(opcao) || opcao =='S' || opcao == 's') 
pega_analise_cfs(DATA);
end
%
% plota os graficos (true) ou não (false)
%
opcao=input('Plotar Grafcios de controle (S/N) ?:','s');
if(isempty(opcao) || opcao == 'S' || opcao =='s') 
PLOTA=true;
else
    PLOTA=false;
end
clear opcao

% nome do arquivo de analise do CFS
%
NOME_DO_ARQUIVO_ANALISE_CFS=strcat('pgbanl.01.',DATA,'00.grb2');
%
% nome do arquivo de CI do CAM ORIGINAL
%
NOME_DO_ARQUIVO_CI_CAM_ORIGINAL='cami_0000-09-01_128x256_L26_c040422.nc';
%
% nome do arquivo de CI do CAM com dados do CFS
%
NOME_DO_ARQUIVO_CI_CAM_ALTERADO=strcat('cami_128x256_L26_c',DATA,'.nc');

%
% ESCALA DE VALORES
% 
% Se deixar o matlab escolher as opcoes ele nos leva ao erro!
% por isso temos que controlar o que é plotado na tela
% altere conforme necessidade
%
escala_temperatura_k=[200,210,220,230,240,250,260,270,280,290,300];
escala_zonal=[-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30];




%
% ACIONA O NCTOOLBOX PARA O MATLAB PODER LER ARQUIVOS GRIB/GRIB2 
%
cd nctoolbox
setup_nctoolbox
cd ..

%
%
% PEGA A DATA DE RODAGEM
% 
% a variavel DATA contem a data do processamento.
% ela pode ser atribuida a variavel "data_de_hoje" ou uma outra data.
%
% DATA_DE_HOJE = pega a data de hoje segundo o sistema operacional
% se for usar outra data que nao a de hoje , use o formato
% YYYYMMD. Descomente ou comente conforme o caso.  
%
% DATANUM (data no sistema do MATLAB). Não mexer.
%


DATA_DE_HOJE=sprintf('%0.8s',datestr(today,30));
%
% se a data nao eh informada, ele usa a data de hoje.
%
if (isempty(DATA))
   DATA=DATA_DE_HOJE;
end 
DATANUM=datenum(DATA,'yyyymmdd');
tmp1=datestr(DATANUM,30);
DATABASE=str2num(tmp1(1:8));
BASEDAY=str2num(tmp1(7:8));
%

%
% TRATAMENTO DO ARQUIVO DE ANÁLISE DO CFS
%
%
% Abre arquivo de CI (condição inicial)
%
ARQUIVO_COM_CAMINHO=sprintf('./DADOS_CI_CC/%s/CI/%s',DATA,NOME_DO_ARQUIVO_ANALISE_CFS);
ng=ncgeodataset(ARQUIVO_COM_CAMINHO);

%
%  interpola a grade do CFS na grade do CAM (plota ambas as interpolaçoes
%  de AJUSTE = true 
%
VAR_CAM_T=interpola_CFS_no_CAM(ng,'Temperature','3D',        PLOTA,1,'mapa_mundi.xls','TEMPERATURA',true,200,300,escala_temperatura_k);
VAR_CAM_Q=interpola_CFS_no_CAM(ng,'Specific_humidity','3D',  PLOTA,2,'mapa_mundi.xls','UMIDADE ESPECIFICA (Q)',false,0,0,0);
VAR_CAM_V=interpola_CFS_no_CAM(ng,'V-component_of_wind','3D',PLOTA,3,'mapa_mundi.xls','COMPONENTE MERIDIONAL DO VENTO',true,-30,30,escala_zonal);
VAR_CAM_U=interpola_CFS_no_CAM(ng,'U-component_of_wind','3D',PLOTA,4,'mapa_mundi.xls','COMPONENTE ZONAL VENTO',true,-30,30,escala_zonal);
VAR_CAM_TS=interpola_CFS_no_CAM(ng,'Temperature_sigma','2D',PLOTA,5,'mapa_mundi.xls','TEMPERATURA DA SUPERFICIE',true,200,300,escala_temperatura_k);
VAR_CAM_PHIS=interpola_CFS_no_CAM(ng,'Geopotential_height_surface','2D',PLOTA,6,'mapa_mundi.xls','GEOPOTENCIAL SUPERFICIE',false,0,0,escala_temperatura_k);
%
% o ideal seria o nivel mais baixo da variavel T mas a diferenca é muito
% pouca entao estou usando TBOT=TS. Melhor que a TBOT de 1950.
%
VAR_CAM_TBOT=interpola_CFS_no_CAM(ng,'Temperature_sigma','2D',true,7,'mapa_mundi.xls','TEMPERATURA DO NIVEL MAIS BAIXO',true,200,300,escala_temperatura_k);

if (PLOTA)
    salva_figuras_png(1,7);
end

%
% grava as variaveis interpoladas no CAM.
% PARA ISSO ABRE O ARQUIVO ORIGINAL, CRIA UMA COPIA E NESTE ULTIMO GRAVA
% OS DADOS ALTERADOS
%
% CRIA OS CAMINHOS CORRETOS DE ACESSO AOS ARQUIVOS NO DIRETORIO
%

NOME_COM_CAMINHO_CAM_CI_ORIGINAL=sprintf('./ARQUIVOS_CAM_ORIGINAIS/%s',NOME_DO_ARQUIVO_CI_CAM_ORIGINAL);
NOME_COM_CAMINHO_CAM_CI_ALTERADO=sprintf('./ARQUIVOS_CAM_ALTERADOS/%s',NOME_DO_ARQUIVO_CI_CAM_ALTERADO);

copyfile(char(NOME_COM_CAMINHO_CAM_CI_ORIGINAL),char(NOME_COM_CAMINHO_CAM_CI_ALTERADO),'f');
%
% ABRE O ARQUIVO A SER ALETRADO DE CI DO CAM
%
% use a rotina abaixo se tiver duvidas de qual numero representa
% a variavel no arquivo do CAM.
% Temperatura = 26 
%
% ncid=netcdf.open(NOME_COM_CAMINHO_CAM_CI_ALTERADO,'NC_WRITE');
% fid = fopen('variaveis_cam.txt','w');
% for i=1:55
% [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,i);
% fprintf(fid,'%d %s\n',i,varname);
% end

ncid=netcdf.open(NOME_COM_CAMINHO_CAM_CI_ALTERADO,'NC_WRITE');


%
% na hora de gravar tenho que dar uma flipdim ordem 3
% para que se grave de forma correta]
%

varid = netcdf.inqVarID(ncid,'T');
netcdf.putVar(ncid,varid,flipdim(VAR_CAM_T,3));

varid = netcdf.inqVarID(ncid,'Q');
netcdf.putVar(ncid,varid,flipdim(VAR_CAM_Q,3));

varid = netcdf.inqVarID(ncid,'U');
netcdf.putVar(ncid,varid,flipdim(VAR_CAM_U,3));

varid = netcdf.inqVarID(ncid,'V');
netcdf.putVar(ncid,varid,flipdim(VAR_CAM_V,3));

varid = netcdf.inqVarID(ncid,'TS');
netcdf.putVar(ncid,varid,flipdim(VAR_CAM_TS,3));

varid = netcdf.inqVarID(ncid,'PHIS');
netcdf.putVar(ncid,varid,flipdim(VAR_CAM_PHIS,3));

varid = netcdf.inqVarID(ncid,'TBOT');
netcdf.putVar(ncid,varid,flipdim(VAR_CAM_TBOT,3));

varid = netcdf.inqVarID(ncid,'ndbase');
netcdf.putVar(ncid,varid,BASEDAY);

varid = netcdf.inqVarID(ncid,'nsbase');
netcdf.putVar(ncid,varid,0);

varid = netcdf.inqVarID(ncid,'nbsec');
netcdf.putVar(ncid,varid,0);

varid = netcdf.inqVarID(ncid,'ndcur');
netcdf.putVar(ncid,varid,BASEDAY);

varid = netcdf.inqVarID(ncid,'date');
netcdf.putVar(ncid,varid,DATABASE);

varid = netcdf.inqVarID(ncid,'datesec');
netcdf.putVar(ncid,varid,0);

varid = netcdf.inqVarID(ncid,'nsteph');
netcdf.putVar(ncid,varid,0);

varid = netcdf.inqVarID(ncid,'nbdate');
netcdf.putVar(ncid,varid,DATABASE);

%
% sincroniza e fecha arquivo
%
netcdf.sync(ncid);
netcdf.close(ncid);
end

