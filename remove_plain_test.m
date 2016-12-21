clear; clc;
i = imread('Data\MultipleObjects\scene_050\frames\frame_300_rgb.png');
id = imread('Data\MultipleObjects\scene_050\frames\frame_450_depth.png');

i = imcrop(i, [200, 0, 500, 250]);
id = imcrop(id, [150, 0, 500,300]);
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
[Pts, rgb] = outlier_rejection(Pts, rgb,250);
pcshow(Pts, rgb);



