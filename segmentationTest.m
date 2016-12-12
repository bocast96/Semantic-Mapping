clear; clc;
% update your path
im = imread('C:\Users\Boris\Documents\School\CS 426 Image Processing\p5\Data\SingleObject\scene_001\frames\image_0_rgb.png');
ic = imcrop(im, [150,150,300,250]);
imshow(ic);
I = rgb2gray(ic);
imshow(I);
%%
background = imopen(I,strel('disk',30));

% Display the Background Approximation as a Surface
figure
surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
ax = gca;
ax.YDir = 'reverse';
%%
I2 = I - background;
imshow(I2)