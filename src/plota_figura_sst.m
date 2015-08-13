function [ ] = plota_figura_sst( Z,MODELO,MAPA_CONTORNO,TITULO,FAIXA)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if (MODELO == 'CFS') 
t1=double(flipdim(shiftdim(Z,2),3));
[ Y ,X ]=ndgrid(-90:90,0:359);
XX=X;
for j=1:181
   for i=1:180
       XX(j,i)=X(j,i);
   end
end

for j=1:181
   for i=181:360
       XX(j,i)=X(j,i)-360;
   end
end
elseif (MODELO =='CAM') 
    
t1=double(flipdim(shiftdim(Z,2),3));
[Y,X ]=ndgrid(-90:1.41:90,1:1.405:360);    
XX=X;
% whos
for j=1:128
    for i=1:128
        XX(j,i)=X(j,i);
    end
end
for j=1:128
    for i=129:256
        XX(j,i)=X(j,i)-360;
    end
end

elseif (MODELO =='OBS')
   t1=flipdim(shiftdim(squeeze(Z),1),3);
   [Y, X]=ndgrid(-90:1.001:90,1:360);
   XX=X;
   whos
   for j=1:180
    for i=180:360
        XX(j,i)=X(j,i)-360;
    end
end
end

% whos

M=xlsread(MAPA_CONTORNO);

contourf(XX,Y,t1);
caxis(FAIXA);
title(TITULO);
hold on;
plot(M(:,1),M(:,2),'k','LineWidth',2);
hold off;
return


% load coast
% coord=zeros(9865,3);
% for i=1:9865
%     coord(i,1)=long(i);
%     coord(i,2)=lat(i);
%     if (long(i) < 0 )
%         coord(i,3)=long(i)+360;
%     else
%         coord(i,3)=long(i);
%     end
% end


end

