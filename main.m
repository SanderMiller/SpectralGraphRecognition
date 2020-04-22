curr_dir = cd;
data_folder = fullfile(curr_dir, "data");
addpath(fullfile(curr_dir, "src"));
[imgs, lbls] = load_imgs_std_sz_lbls(data_folder, "*.jpg", [500, 500]);

%%
rgbIm = squeeze(imgs(1, :, :, :));
grayIm = rgb2gray(rgbIm);

edgeThresh = 0.9;
distThresh = 60;
edgeIm = edge(grayIm, 'Canny', edgeThresh);
[Gx,Gy] = imgradientxy(grayIm, 'Sobel');
[Gmag,Gdir] = imgradient(Gx,Gy);
cornerIm = corner(edgeIm, 'Harris');
theta = zeros(length(cornerIm(:,1)));
for i = 1:length(cornerIm(:,1))
    theta(:,i) = Gdir(cornerIm(i,2),cornerIm(i,1));
end

D = pdist(cornerIm);
Dist = squareform(D);
Dist(Dist>distThresh) = 0;
Y = Dist;
Y(Y>0) = 1;
ThetaI = Y.*theta;
ThetaIpi = ThetaI;
ThetaIpi(ThetaIpi>0) = 2*pi;
ThetaI = abs(ThetaI - ThetaIpi);
ThetaJ = Y.*theta';
ThetaJpi = ThetaJ;
ThetaJpi(ThetaJpi>0) = 2*pi;
ThetaJ = abs(ThetaJ - ThetaIpi);
W = abs(ThetaI-ThetaJ)./(Dist.^2);
W(isnan(W))=0;
W = (W+W')/2;
G = graph(W)


subplot(2,3,1)
imshow(grayIm)
title('Original Image')

subplot(2,3,2)
imshow(edgeIm)
title('Edge Detection')

subplot(2,3,3)
imshow(edgeIm)
hold on
plot(cornerIm(:,1), cornerIm(:,2),'r.')
title('Harris Corner Detection')

subplot(2,3,4)
plot(G,'Layout','force')
title('Layed Out Graph')

subplot(2,3,5)
plot(G,'XData',cornerIm(:,1),'YData',-cornerIm(:,2))
title('In Place Graph')

subplot(2,3,6)
plot(G,'XData',cornerIm(:,1),'YData',-cornerIm(:,2),'EdgeLabel',G.Edges.Weight)
title('In Place Graph with Weights')


