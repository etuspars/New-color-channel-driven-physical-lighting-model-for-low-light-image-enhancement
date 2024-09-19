% New color channel driven physical lighting model for low-light image enhancement
% 
% If you use this code, please cite the following paper:
% @article{kucuk2024new,
%   title={New Color Channel Driven Physical Lighting Model for Low-Light Image Enhancement},
%   author={Kucuk, S and Severoglu, N and Demir, Y and Kaplan, NH},
%   journal={Digital Signal Processing},
%   pages={104757},
%   year={2024},
%   publisher={Elsevier}
% }

clc;clear all;close all

input_img = imread("images\1.jpg");

avg=mean2(im2double(input_img));
IMAX = max(double(input_img(:)));
input_img = double(input_img)/IMAX;

                
gam=.6;
 
    if avg<0.25
        gam=0.4;
    end

    if avg>0.5
        gam=0.8;
    end

input_img = power(input_img,gam);
            
R_channel =(input_img(:,:,1));
G_channel =(input_img(:,:,2));
B_channel =(input_img(:,:,3)); 
        
NCC = 0.299*input_img(:,:,1)+0.587*input_img(:,:,2)+0.114*input_img(:,:,3)-(max(input_img,[],3))+(min(input_img,[],3));
            
kernel=ones(31)/(31^2);
NCC=imfilter(NCC,kernel,"symmetric");

atmsphrclight=atmLight(input_img, NCC);
lsar=(1-.2*NCC);
lsar=imguidedfilter(lsar);
lsar0=0.0001;
        
R_out = atmsphrclight(1)+ (R_channel-atmsphrclight(1))./max(lsar,lsar0);
G_out = atmsphrclight(2)+ (G_channel-atmsphrclight(2))./max(lsar,lsar0);
B_out = atmsphrclight(3)+ (B_channel-atmsphrclight(3))./max(lsar,lsar0);
output = cat(3,R_out,G_out,B_out);
        
imshow(output)


