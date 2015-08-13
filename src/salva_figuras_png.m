function salva_figuras_png(inicio,fim)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

for fig=inicio:fim
 saveas(fig,strcat('figura',num2str(fig)),'png');
end
end