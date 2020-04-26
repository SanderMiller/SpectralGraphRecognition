%% Load and Crop Image
clear;
clear fig;
curr_dir = cd;
data_folder = fullfile(curr_dir, "data");
addpath(fullfile(curr_dir, "src"));
[imgs, lbls] = load_imgs_std_sz_lbls(data_folder, "*.jpg", [500, 500]);

%% Visualizing Graphs With Random Image Rotations
<<<<<<< HEAD
rgbIm = squeeze(imgs(4, :, :, :));
grayIm = rgb2gray(rgbIm);

[G, points] = image2Graph(grayIm, 100, 100);

subplot(1,4,1)
imshow(grayIm)


subplot(1,4,2)
p1 = plot(G,'XData',points(:,1),'YData',points(:,2));
=======
figure(1);
for i = 1:2*length(lbls)
rgbIm = squeeze(imgs(ceil(i/2), :, :, :));
grayIm = imrotate(rgb2gray(rgbIm), mod(i+1,2)*randi(360,1));
[G, normalizedPoints, ~] = image2Graph(grayIm, 100, 100);
subplot(2*length(lbls),4,i*4-3)
imshow(grayIm)
if i == 1
   title('Original Image')
end
subplot(2*length(lbls),4,i*4-2)
p1 = plot(G,'XData',normalizedPoints(:,1),'YData',normalizedPoints(:,2));
>>>>>>> 593ca7a4d892801224ba4405c3890d00f598031c
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
