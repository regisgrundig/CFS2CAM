function [ VAR_INTERPOLADA ] = interpola_CFS_no_CAM(POINTER_GRIB, CAMPO, TIPO,PLOTA_FIGURAS , NUM_FIGURA , MAPA_CONTORNO, NOME_VARIAVEL ,AJUSTE,LIM_MIN,LIM_MAX,VALORES)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


if (TIPO=='3D') 
    NIVEIS=37;
else
    NIVEIS=1;
end
    
    
%
% 
%
%  As variaveis do cam e cfs tem dimensoes trocadas  
%  Rearrumo as dimensoes da matriz (permute) 
%  CAM 
%  de  Y Z X  para  X Y Z
%  CFS
%  de Z Y X  para X Y Z
%
if (TIPO=='3D')
VAR_CFS_T=permute(squeeze(POINTER_GRIB{CAMPO}(:,:,:)),[3 2 1]);
else
    VAR_CFS_T=permute(squeeze(POINTER_GRIB{CAMPO}(:,:)),[2 1]);
end    
%
% crio uma grade vazia do CFS  (360x181x37)
% mas georefenciada.
%
[CFS_X ,CFS_Y ,CFS_Z ]=ndgrid(1:360,1:181,1:NIVEIS);

%  crio uma grade vazia para o CAM 256x128x26
% mas georefenciada
[CAM_X, CAM_Y, CAM_Z]=ndgrid(1:1.405:360,1:1.41:181,1:1.39:NIVEIS);
VAR_INTERPOLADA=zeros(CAM_X,CAM_Y,CAM_Z);

%
% faço a interpolaçao 3D
%
if (TIPO=='3D')
TMP1=griddedInterpolant(CFS_X,CFS_Y,CFS_Z,VAR_CFS_T,'spline');
TMP2=TMP1(CAM_X,CAM_Y,CAM_Z);
VAR_CAM_T=permute(TMP2,[ 1 3 2 ] );
else
TMP1=griddedInterpolant(CFS_X,CFS_Y,VAR_CFS_T,'spline');
TMP2=TMP1(CAM_X,CAM_Y);
VAR_CAM_T=permute(TMP2,[ 1 3 2 ] );
end    

%
% plota as figuras do CFS e CAM se PLOAT_FIGURA=true
%
if (PLOTA_FIGURAS)
   figure(NUM_FIGURA);
   clf;
   TMP1=squeeze(VAR_CFS_T(:,:,1));
   TMP2=squeeze(VAR_CAM_T(:,1,:));
   plota_figura_comparacao(TMP1,TMP2,MAPA_CONTORNO,NOME_VARIAVEL,AJUSTE,LIM_MIN,LIM_MAX,VALORES)
end

VAR_INTERPOLADA=VAR_CAM_T;


end

