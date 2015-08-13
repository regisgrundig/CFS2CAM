function cfs2cam_sst( DATA )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%DATA='20150315'
%
% ACIONA O NCTOOLBOX PARA O MATLAB PODER LER ARQUIVOS GRIB/GRIB2 
%
cd nctoolbox
setup_nctoolbox
cd ..

%
% definiçaõ do arquivo de TSM do CAM (orignal e o de saida)
% 
ARQUIVO_TSM_CAM_ORIGINAL='./ARQUIVOS_CAM_ORIGINAIS/sst_HadOIBl_bc_128x256_clim_c031031.nc';
ARQUIVO_TSM_CAM_FINAL=strcat('./ARQUIVOS_CAM_ALTERADOS/sst_HadOIBl_bc_128x256_clim_c',DATA,'.nc');
copyfile(ARQUIVO_TSM_CAM_ORIGINAL,char(ARQUIVO_TSM_CAM_FINAL));



%
% adquire dados
%
%opcao=input('Baixar os dados de análise do CFS (S/N)?','s');
%if (isempty(opcao) || opcao =='S' || opcao == 's') 
[ ARQUIVOS_TSM_CFS , ARQUIVOS_SKINTEMP_CFS]=pega_sst_cfs(DATA);
%end
%
% Atualizar dados de tsm observada
%
%opcao=input('Atualizar TSM Observada (S/N)?','s');
%if (isempty(opcao) || opcao =='S' || opcao == 's') 
[ ARQUIVOS_TSM_OBS]=pega_tsm_observada(DATA);
%end
%
%plota os graficos (true) ou não (false)
%
opcao=input('Plotar Grafcios de controle (S/N) ?:','s');
if(isempty(opcao) || opcao == 'S' || opcao =='s') 
PLOTA=true;
else
     PLOTA=false;
end
clear opcao

%
% define escala de valores dos graficos
%

FAIXA1=[200 300];
FAIXA2=[260 300];

%
% Leitura dos dados de TSm do CFS e do nivel sigma 1
% para ajudar na interpolação 
% 
% entra no dirrtorio de dados segunda DATA
%
cd('DADOS_CI_CC')
cd(DATA);
cd('SST');
%
% vou ler 18 arquivos
% 9 de TSM prevista
% 9 de temp skin temp 
%

for i=1:9
    %
    % ler arquivos de TSM e armazenar na
    % matriz TSM_DO_CFS{9}
    %
    id=ncgeodataset(char(ARQUIVOS_TSM_CFS{i}));
    TSM_DO_CFS(i,:,:,:)=squeeze(id{'Temperature'}(:,:,:));
    %
    % ler arquivos de TSM e armazenar na
    % matriz TSM_DO_CFS{9}
    %
    id=ncgeodataset(char(ARQUIVOS_SKINTEMP_CFS{i}));
    SKINTEMP_CFS(i,:,:)=squeeze(id{'Temperature_sigma'}(1,:,:));
end

%
% retorno diretorio principal
%
cd('..')
cd('..')
cd('..')


%
% na TSM do CFS TEM MASCARA DE TERRA, O QUE ATRAPALHA
% A INTERPOLAÇÃO. ENTAO USO TEMPERATURA SIGMA 1 PARA
% TROCAR A AMSCARA DE TERRA POR TEMPERATURA SKINTEMP
% AO FINAL TEMOS TSM_CFS_FINAL.
%
[ n , jj , ii]=size(TSM_DO_CFS);
TSM_CFS_FINAL=TSM_DO_CFS;
for k=1:n
    for j=1:jj
        for i=1:ii
            if (isnan(TSM_DO_CFS(k,j,i)) == 1) 
             TSM_CFS_FINAL(k,j,i)=SKINTEMP_CFS(k,j,i);
                 %else
             %    TSM_CFS_FINAL(k,j,i)=TSM_DO_CFS(k,j,i);
            end
        end
   end

end

%
%
%
if (PLOTA)
for ii=1:9
    original=flipdim(squeeze(TSM_DO_CFS(ii,:,:)),1);
    skintemp=flipdim(squeeze(SKINTEMP_CFS(ii,:,:)),1);
    nova_tsm=flipdim(squeeze(TSM_CFS_FINAL(ii,:,:)),1);
    if (ii <=3)
       figure(8)
       subplot(3,3,ii)
       plota_figura_sst(original,'CFS','mapa_mundi.xls',strcat('TSM ORIGINAL CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,3+ii)
       plota_figura_sst(skintemp,'CFS','mapa_mundi.xls',strcat('SKINTEMP CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,6+ii)
       plota_figura_sst(nova_tsm,'CFS','mapa_mundi.xls',strcat('TSM+SKINTEMP CFS - PREV:',num2str(ii)),FAIXA1);
    end
    if (ii >3 && ii <=6)
       figure(9)
       subplot(3,3,ii-3)
       plota_figura_sst(original,'CFS','mapa_mundi.xls',strcat('TSM ORIGINAL CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,ii)
       plota_figura_sst(skintemp,'CFS','mapa_mundi.xls',strcat('SKINTEMP CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,ii+3)
       plota_figura_sst(nova_tsm,'CFS','mapa_mundi.xls',strcat('TSM+SKINTEMP CFS - PREV:',num2str(ii)),FAIXA1);
    end
    if (ii >6)
       figure(10)
       subplot(3,3,ii-6)
       plota_figura_sst(original,'CFS','mapa_mundi.xls',strcat('TSM ORIGINAL CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,ii-3)
       plota_figura_sst(skintemp,'CFS','mapa_mundi.xls',strcat('SKINTEMP CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,ii)
       plota_figura_sst(nova_tsm,'CFS','mapa_mundi.xls',strcat('TSM+SKINTEMP CFS - PREV:',num2str(ii)),FAIXA1);
    end
    
end
end



%
% TSM OBSERVADA
%
cd('TSM_OBSERVADA');
cd('OISSTV2');
%
% tratamento da tsm observada
%
TSM_OBSERVADA_ORIGINAL=zeros(12,360,180);
TSM_OBSERVADA_INTERPOLADA_CAM=zeros(12,256,128);
for i=1:12
    %
    % abro o arquivo
    %
    id=ncgeodataset(ARQUIVOS_TSM_OBS{i});
    TMP1=shiftdim(squeeze(id{'Temperature'}(:,:)),1);
    %whos
    % interpola na grade do CAM
    %
    [X, Y]=ndgrid(1:360,1:180);
    [X1, Y1]=ndgrid(1:1.405:360,1:1.40:180);
    D=griddedInterpolant(X,Y,TMP1,'spline');
    %
    % guardo a tsm observada de acordo ocm o mes. 
    % isto é record#1 jan  record#2 fevereiro etc...
    %
    TMP2=D(X1,Y1);
    mes=str2num(ARQUIVOS_TSM_OBS{i}(13:14));
    TSM_OBSERVADA_ORIGINAL(mes,:,:)=TMP1;
    TSM_OBSERVADA_INTERPOLADA_CAM(mes,:,:)=TMP2;
end
     
cd('..');
cd('..');



 if (PLOTA)

for i=1:12
    figure(11);
    subplot(4,3,i);
    original=flipdim(squeeze(TSM_OBSERVADA_ORIGINAL(i,:,:)),2);
    plota_figura_sst(original,'OBS','mapa_mundi.xls',strcat('TSM OBSERVADA - ORIGEM:',ARQUIVOS_TSM_OBS{i}),FAIXA2);
    figure(12);
    subplot(4,3,i);
    original=flipdim(shiftdim(squeeze(TSM_OBSERVADA_INTERPOLADA_CAM(i,:,:)),1),1);
    plota_figura_sst(original,'CAM','mapa_mundi.xls',strcat('TSM OBS. INTERPOLADA CAM-ORIGEM:',ARQUIVOS_TSM_OBS{i}),FAIXA2);
    
end
end


%
% Abre arquivo do CAM ORIGINAL
% para modelo de matriz e plotagem dos mapas
%
idcam1=ncgeodataset(char(ARQUIVO_TSM_CAM_ORIGINAL));
TSM_DO_CAM_ORIGINAL=idcam1{'SST_cpl'}(:,:,:);


if (PLOTA)
figure(13);
clf;
for i=1:12
    subplot(4,3,i);
    original=squeeze(TSM_DO_CAM_ORIGINAL(i,:,:))+273.15;
    plota_figura_sst(original,'CAM','mapa_mundi.xls',strcat('TSM DO CAM - MES:',num2str(i)),FAIXA2);
end
end

%
%  IGUALA_SE A TSM OBSERVADA (12 MESES) A TSM DO CAM
%
%
% ALTERA-SE A DIMENSAO DE 12X256X128  PARA 12X128X256 
%

     TSM_OBSERVADA_INTERPOLADA_CAM=permute(TSM_OBSERVADA_INTERPOLADA_CAM,[1 3 2]);
%     
   





%--------------------------------------------------------------------------
% TENHO QUE TROCAR AS DIMENSOES PARA SE ADEQUAR AO CAM (X,Y) -> (Y,X)
%--------------------------------------------------------------------------
%for k=1:9
% TSM_CFS_FINAL(k,:,:)=shiftdim(TSM_CFS_FINAL(k,:,:),1);
 %TSM_CFS_FINAL(k,:,:)=TSM_CFS_FINAL(k,:,:);
%nd
TSM_CFS_FINAL=permute(TSM_CFS_FINAL,[1 2 3]);
%
% INTERPOLO A TSM CFS FINAL NA  GRADE DO CAM
%
% CRIO A GRADE DO CFS MODELO E CAM MODELO
%
TSM_CAM_FINAL= TSM_OBSERVADA_INTERPOLADA_CAM;
[X, Y ]=ndgrid(1:181,1:360);
[X1, Y1]=ndgrid(1:1.41:181,1:1.405:360);
%
% INTERPOLAÇÃO 
%
for k=1:9
sst=squeeze(TSM_CFS_FINAL(k,:,:));    
D=griddedInterpolant(X,Y,sst,'spline');
TSM_CAM_FINAL(k,:,:)=D(X1,Y1);
end


if (PLOTA)
for ii=1:9
    original=flipdim(squeeze(TSM_DO_CFS(ii,:,:)),1);
    nova_tsm=flipdim(squeeze(TSM_CFS_FINAL(ii,:,:)),1);
    tsm_cam=flipdim(squeeze(TSM_CAM_FINAL(1,:,:)),1);
    
  if (ii <=3)
       figure(14)
       subplot(3,3,ii)
       plota_figura_sst(original,'CFS','mapa_mundi.xls',strcat('TSM ORIGINAL CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,3+ii)
       plota_figura_sst(nova_tsm,'CFS','mapa_mundi.xls',strcat('TSM FINAL CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,6+ii)
       plota_figura_sst(tsm_cam,'CAM','mapa_mundi.xls',strcat('TSM FINAL CAM - PREV:',num2str(ii)),FAIXA1);
  end
  if (ii >3 && ii <=6)
       figure(15)
       subplot(3,3,ii-3)
       plota_figura_sst(original,'CFS','mapa_mundi.xls',strcat('TSM ORIGINAL CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,ii)
       plota_figura_sst(nova_tsm,'CFS','mapa_mundi.xls',strcat('TSM FINAL CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,ii+3)
       plota_figura_sst(tsm_cam,'CAM','mapa_mundi.xls',strcat('TSM FINAL CAM - PREV:',num2str(ii)),FAIXA1);
  end
    if (ii >6)
       figure(16)
       subplot(3,3,ii-6)
       plota_figura_sst(original,'CFS','mapa_mundi.xls',strcat('TSM ORIGINAL CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,ii-3)
       plota_figura_sst(nova_tsm,'CFS','mapa_mundi.xls',strcat('TSM FINAL CFS - PREV:',num2str(ii)),FAIXA1);
       subplot(3,3,ii)
       plota_figura_sst(tsm_cam,'CAM','mapa_mundi.xls',strcat('TSM FINAL CAM - PREV:',num2str(ii)),FAIXA1);
    end
    
  end
end

if (PLOTA)
    salva_figuras_png(8,16);
end

%
% GRAVA NOVA TSM NO ARQUIVO FINAL DO CAM
%
ncid=netcdf.open(ARQUIVO_TSM_CAM_FINAL,'NC_WRITE');
[varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,0);
varid = netcdf.inqVarID(ncid,varname);
TSM_CAM= netcdf.getVar(ncid,varid);


%--------------------------------------------------------------------------
%
%  GRAVA A NOVA TSM NO ARQUIVO DE TSM DO CAM   (UFA!!!) 
%--------------------------------------------------------------------------
netcdf.putVar(ncid,varid,flipdim(permute(TSM_CAM_FINAL,[3 2 1]),2)-273.15);
%--------------------------------------------------------------------------
%  FINALIZA
%--------------------------------------------------------------------------
netcdf.sync(ncid)
netcdf.close(ncid)

end

