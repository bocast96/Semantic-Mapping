% Segmenting object 000
clear; clc;
% update your path
path = 'Data\SingleObject\scene_000\';
in = 'frames\';
out = 'segmented_2d\';
label = 'frame_';
labEnd = '_rgb.png';

for i = 0:0
    num = num2str(i);
    im = imread(strcat(path, in, label, num, labEnd)); 
    %imshow(im);
    ic = imcrop(im, [150,140,300,250]);
    %ic = rgb2gray(ic);
    background = imopen(ic,strel('disk',30));
    i_seg = ic - background;
    outfile = strcat(path, out, 'seg_obj_', num, labEnd);
    imwrite(i_seg, outfile);
    imshow(i_seg);
end

%%
id = imread(strcat(path, in, label, '0_depth.png')); 
id = imcrop(id, [150,140,300,250]);
%%
i_msk = rgb2gray(i_seg);
i_msk = imbinarize(i_msk,0.2);
imf = imfill(i_msk, 'holes');
%imf = imopen(imf,strel('line', 5,2));
imf = bwareafilt(imf,1);
imshow(imf);

%%
id = im2double(id);
imf = im2double(imf);
id = id.*imf;
imshow(id*100);

%%
ic = im2double(ic);
im = ic.*repmat(imf,[1,1,3]);
imshow(im);

%%
im = im2uint8(im);
id = im2uint16(id);
%%
[pcx, pcy, pcz, r, g, b, D_, X, Y,validInd] = depthToCloud_full_RGB(id, im, 'params/calib_xtion.mat');
%%
Pts = [pcx pcy pcz];
pcshow(Pts,[r g b]/255);
drawnow;
title('3D Point Cloud');








