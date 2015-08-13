function [ ] = plota_figura_comparacao( Z1,Z2,MAPA_CONTORNO,CAMPO,AJUSTE,LIM_MIN,LIM_MAX,VALORES)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if (nargin <5) 
    disp 'erro. falta argumentos obrigatorios'
    quit cancel 
end
    
    
t1=double(flipdim(shiftdim(Z1,1),1));
[ Y1 ,X1 ]=ndgrid(-90:90,0:359);
XX1=X1;
for j=1:181
   for i=1:180
       XX1(j,i)=X1(j,i);
   end
end

for j=1:181
   for i=181:360
       XX1(j,i)=X1(j,i)-360;
   end
end
   
t2=double(flipdim(shiftdim(Z2,1),1));
[Y2,X2 ]=ndgrid(-90:1.41:90,1:1.405:360);    
XX2=X2;

for j=1:128
    for i=1:128
        XX2(j,i)=X2(j,i);
    end
end
for j=1:128
    for i=129:256
        XX2(j,i)=X2(j,i)-360;
    end
end



if (AJUSTE) 
M=xlsread(MAPA_CONTORNO);
h1=subplot(211);
contourf(XX1,Y1,t1,VALORES);
colorbar;
hold on;
plot(M(:,1),M(:,2),'k','LineWidth',2);
title(strcat(CAMPO,' CFS '));
h2=subplot(212);
contourf(XX2,Y2,t2,VALORES);
colorbar;
hold on;
plot(M(:,1),M(:,2),'k','LineWidth',2);
title(strcat(CAMPO,' CAM '));
set([h1 h2],'clim',[LIM_MIN,LIM_MAX]);
else
M=xlsread(MAPA_CONTORNO);
h1=subplot(211);
contourf(XX1,Y1,t1);
colorbar;
hold on;
plot(M(:,1),M(:,2),'k','LineWidth',2);
title(strcat(CAMPO,' CFS '));
h2=subplot(212);
contourf(XX2,Y2,t2);
colorbar;
hold on;
plot(M(:,1),M(:,2),'k','LineWidth',2);
title(strcat(CAMPO,' CAM '));
   
end

return



end
