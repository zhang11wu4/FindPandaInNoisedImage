clear all;
close all;
clc;
img=imread('hidden panda_0.jpg');  
img_gray = rgb2gray(img);
subplot(2,3,1);imshow(img);title('org');
img_fft2 = fft2(img_gray);%fourier transform
img_fft2_shift = fftshift(img_fft2);%fourier centerize
% %get rect[386:414,239:327]
% im_rect = (real(log10(1+abs(img_fft2_shift))));
% im_rect_stretch=uint8(255*((im_rect-min(im_rect(:)))/(max(im_rect(:))-min(im_rect(:)))));
% im_rect_bw = im2bw(im_rect_stretch,0.7);
% figure;
% imshow(im_rect_bw);
% figure;
% imshow(im_rect,[]);
% imwrite(im_rect_stretch,'frequent.bmp');
% %get rect[386:414,239:327] end
img_filter = zeros(size(img_fft2_shift));%mask operation,get the center rectangle,just is low filter
img_filter(386:414,239:327,:) = img_fft2_shift(386:414,239:327,:);%rect[386:414,239:327] is got manually
img_shift_i = ifftshift(img_filter);%inverse shift
img_fft2_i = ifft2(img_shift_i);%inverse fft2

im = uint8(real(img_fft2_i));
subplot(2,3,2);imshow(im);title('fft2');
imwrite(im,'inverse_fourier.bmp');
im=255*((im-min(im(:)))/(max(im(:))-min(im(:))));%stretch, set the image range [0 255]
subplot(2,3,3);imshow(im);title('stretch');

fs = fspecial('gaussian',3,9);
im_filter=filter2(fs,im); 

subplot(2,3,4);imshow(im_filter);title('gaussian');
imwrite(im_filter,'gaussian.bmp');
st = strel('disk',7);
im_filter_dilate=imdilate(im_filter,st);
im_filter_dilate_erode=imerode(im_filter_dilate,st);
subplot(2,3,5);imshow(im_filter_dilate_erode);title('dilate&erode'); 
imwrite(im_filter_dilate_erode,'close.bmp');
level = graythresh(im_filter_dilate_erode);
BW = im2bw(im_filter_dilate_erode,level);
subplot(2,3,6);imshow(BW);title('binary');