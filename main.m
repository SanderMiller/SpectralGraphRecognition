%% Load and Crop Image
clear;
clear fig;
curr_dir = cd;
data_folder = fullfile(curr_dir, "data");
addpath(fullfile(curr_dir, "src"));
[imgs, lbls] = load_imgs_std_sz_lbls(data_folder, "*.jpg", [500, 500]);

%% Visualizing Graphs With Random Image Rotations
figure(1);
for i = 1:2*length(lbls)
rgbIm = squeeze(imgs(ceil(i/2), :, :, :));
grayIm = imrotate(rgb2gray(rgbIm),mod(i+1,2)*randi(360,1));
[G, points] = image2Graph(grayIm, 100, 100);
subplot(2*length(lbls),4,i*4-3)
imshow(grayIm)
if i == 1
   title('Original Image')
end
subplot(2*length(lbls),4,i*4-2)
p1 = plot(G,'XData',points(:,1),'YData',points(:,2));
p1.NodeColor = 'r';
p1.NodeLabel = [];
if i == 1
   title('In Place Graph')
end
subplot(2*length(lbls),4,i*4-1)
p2 = plot(G,'Layout','force');
p2.NodeColor = 'r';
p2.NodeLabel = [];
if i == 1
   title('Expanded Graph')
end
subplot(2*length(lbls),4,i*4)
L = laplacian(G);
e = eig(L);
histogram(e, length(unique(e)));
if i == 1
   title('Eigen Values');
end
end



