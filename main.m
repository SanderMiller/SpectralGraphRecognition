curr_dir = cd;
data_folder = fullfile(curr_dir, "data");
addpath(fullfile(curr_dir, "src"));
[imgs, lbls] = load_imgs_std_sz_lbls(data_folder, "*.jpg", [500, 500]);

%%
rgbIm = squeeze(imgs(1, :, :, :));
grayIm = rgb2gray(rgbIm);

edgeThresh = 0.7;
distThresh = 60;
edgeIm = edge(grayIm, 'Canny', edgeThresh);
[Gx,Gy] = imgradientxy(grayIm, 'Sobel');
[Gmag, Gdir] = imgradient(Gx,Gy);
corners = detectHarrisFeatures(grayIm, 'FilterSize', 9, 'MinQuality', 0.01);
corners = corners.selectStrongest(50);
theta = zeros(1, 50);
for i = 1:50
    loc = corners(1).Location;
    theta(i) = Gdir(int16(loc(1)), int16(loc(2)));
end
imshow(grayIm);
hold on;
plot(corners)

%%
% Create the Hough transform using the binary image.
rot_edge_im = imrotate(edgeIm, 33, 'crop');
[H,T,R] = hough(rot_edge_im);
imshow(H,[],'XData',T,'YData', R, ...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

% Find peaks in the Hough transform of the image.
P  = houghpeaks(H, 100, 'threshold', ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');

lines = houghlines(rot_edge_im ,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(rot_edge_im), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end


%%
D = pdist(corners);
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
plot(corners(:,1), corners(:,2),'r.')
title('Harris Corner Detection')

subplot(2,3,4)
plot(G,'Layout','force')
title('Layed Out Graph')

subplot(2,3,5)
plot(G,'XData',corners(:,1),'YData',-corners(:,2))
title('In Place Graph')

subplot(2,3,6)
plot(G,'XData',corners(:,1),'YData',-corners(:,2),'EdgeLabel',G.Edges.Weight)
title('In Place Graph with Weights')


