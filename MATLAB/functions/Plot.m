function Plot()
% Author: Seyed Hamid Reza Sanei Date: 06/10/2014
%this function adjusts all the font size and style in an image
% The general format for changing the default property is   'Default<Object><Property>'
set(0,'defaultTextFontSize',14)
set(0,'DefaultTextFontname', 'arial')
set(0,'defaultAxesFontSize',14)
set(0,'defaultAxesFontName','arial')
set(0,'DefaultLineLineWidth',2)
set(0,'DefaultLineMarkerSize',14)
set(gcf,'color',[1 1 1])
axis square tight xy 
grid on
