clear; clc;
i = imread('Data\SingleObject\scene_000\frames\frame_0_rgb.png');
id = imread('Data\SingleObject\scene_000\frames\frame_0_depth.png');

i = imcrop(i, [100, 100, 300, 300]);
id = imcrop(id, [100,100,300,300]);

[pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(id, i, 'params/calib_xtion.mat');
Pts = [pcx pcy pcz];
rgb = [r g b]/255;
pcshow(Pts, rgb);

%%
[Pts, rgb] = removeLargestPlain(Pts, rgb, 0.1, 100);
%%
figure;
[Pts, rgb] = removeLargestPlain(Pts, rgb, 0.1, 10);
%%
figure;
pcshow(Pts, rgb);
