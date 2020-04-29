%% Load and Crop Image
clear;
clear fig;
curr_dir = cd;
data_folder = fullfile(curr_dir, "data");
addpath(fullfile(curr_dir, "src"));
[imgs, lbls] = load_imgs_std_sz_lbls(data_folder, "*.jpg", [500, 500]);

%% Visualizing Image Graphs and Normalized Eigen Values 

rgbIm = squeeze(imgs(1, :, :, :));
grayIm = rgb2gray(rgbIm);
[G, points] = image2Graph(grayIm, 100, 100);
D = diag(degree(G));
L = full(laplacian(G));
D = D.^-.5;
D(~isfinite(D)) = 0;
symL = D*L*D;
e = eig(symL);

rgbIm = squeeze(imgs(1, :, :, :));
grayIm2 = imrotate(rgb2gray(rgbIm),47);
[G2, points2] = image2Graph(grayIm2, 100, 100);
D2 = diag(degree(G2));
L2 = full(laplacian(G2));
D2 = D2.^-.5;
D2(~isfinite(D2)) = 0;
symL2 = D2*L2*D2;
e2 = eig(symL2);

subplot(2,2,1)
imshow(grayIm)

subplot(2,2,2)
imshow(grayIm2)

subplot(2,2,3)
p2 = plot(G,'Layout','force');
p2.NodeColor = 'r';
p2.NodeLabel = [];



subplot(2,2,4)
p3 = plot(G2,'Layout','force');
p3.NodeColor = 'r';
p3.NodeLabel = [];
xpos = 0.3; ypos = 0.8;
distance = norm(e-e2);
text(xpos, ypos, sprintf('Distance: %d',distance))


%%
%{
subplot(1,4,1)
imshow(grayIm)

subplot(1,4,2)
p1 = plot(G,'XData',points(:,1),'YData',points(:,2));
p1.NodeColor = 'r';
p1.NodeLabel = [];


subplot(1,4,3)
p2 = plot(G,'Layout','force');
p2.NodeColor = 'r';
p2.NodeLabel = [];

subplot(1,4,4)
D = diag(degree(G));
L = full(laplacian(G));
D = D.^-.5;
D(~isfinite(D)) = 0;
symL = D*L*D;
e = eig(symL);
histogram(e, 'BinEdges',-0:.02:2);
hold off

%%
rgbIm = squeeze(imgs(3, :, :, :));
grayIm2 = imrotate(rgb2gray(rgbIm),40);

[G2, points2] = image2Graph(grayIm2, 100, 100);
D2 = diag(degree(G2));
L2 = full(laplacian(G2));
D2 = D2.^-.5;
D2(~isfinite(D2)) = 0;
symL2 = D2*L2*D2;
e2 = eig(symL2);

%}

