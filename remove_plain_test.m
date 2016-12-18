clear; clc;
i = imread('Data\SingleObject\scene_022\frames\frame_0_rgb.png');
id = imread('Data\SingleObject\scene_022\frames\frame_0_depth.png');

i = imcrop(i, [50, 0, 400, 400]);
id = imcrop(id, [50, 0, 400,400]);
imshow(i);

%%
[pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(id, i, 'params/calib_xtion.mat');
Pts = [pcx pcy pcz];
rgb = [r g b]/255;
pcshow(Pts, rgb);

%%
[Pts, rgb] = removeLargestPlain(Pts, rgb, 15, 20);
pcshow(Pts, rgb);

%%
[Pts, rgb] = removeLargestPlain(Pts, rgb, 15, 20);
pcshow(Pts, rgb);

%%
[Pts, rgb] = outlier_rejection(Pts, rgb, 250);
pcshow(Pts, rgb);



