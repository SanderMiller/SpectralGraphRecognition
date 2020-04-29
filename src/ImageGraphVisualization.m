% Script Deprecated

figure(1);
if length(lbls)>100
    numImages = 3;
else
    numImages = length(lbls);
end
for i = 1:2*numImages
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
D = diag(degree(G));
L = full(laplacian(G));
D = D.^-.5;
D(~isfinite(D)) = 0;
symL = D*L*D;
e = eig(symL);
histogram(e, length(e));
if i == 1
   title('Eigen Values');
end
end