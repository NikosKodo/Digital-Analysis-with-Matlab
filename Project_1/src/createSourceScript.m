clear;clc;
% in this script we try to create the three sources
M = 1e4; % number of samples

% -----------------------FIRST SOURCE------------------------
% crete M samples of a complex Gaussian allocation
% t ~ CN(0,1).
% t = (randn(M,1)+sqrt(-1)*randn(M,1))./sqrt(2);
% x_A = abs(t).^2; % first x[] source

% % -----------------------SECOND SOURCE-----------------------
% % crete M samples of a uniform allocation
% % in area [0, 4].
% x_B=4*rand(M,1);	% second x[] source

% % -----------------------THIRD SOURCE------------------------
% loading image
load mercs2.mat
% imshow(uint8(mercs))
% pause(3)
% close

% transform the image in order to bring it's dynamic range to
% [-1,1];
xr = mercs;
x = mercs(:);% third x[] source
x = (x-min(x));
f=(min(x)+max(x))/2;
x_C = (x-f) / f;
