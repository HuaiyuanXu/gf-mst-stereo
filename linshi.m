clear;%��������ռ�����б���
clc;%�������ڵ����ݣ��Թ��������е�ȫ���������κ�Ӱ��

%ѡ��ͼ��
im_num=3;    %tsukuba:1  venus:2  teddy:3  cones:4
%�����ݶ�ƥ����۱���ϵ��  0.89
alpha_grad=0.89;
%������ɫƥ����۽ض�ֵ
thres_color=0.0275;
%�����ݶ�ƥ����۽ض�ֵ
thres_grad=0.0078;
%���ñ�Ե���ش���ֵ
cost_border=0.012;
%���������˲����ڳߴ����
win_radius=9;
%���������˲�epsilonֵ
epsilon=0.0001;
%���ü�Ȩ��ֵ�˲����ڳߴ����
win_median_radius=9;
%���ü�Ȩ��ֵ�˲�sigmaֵ
sigma_c=0.1;
sigma_p=14.1;
%�쳣���ڽ�ƥ�䴰�ڴ�С
r1=25; 
%DSI�����ֵ
fai=0;
%CBOF���㲻�ȶ�����Ӳ����
gama_c=0.51;  %��ɫ����
gama_r=0.0915;  %λ�þ���
CBOF_window=3;  %���ڴ�С
r=CBOF_window;
CBOFmoder = zeros(r,r);
for i=1:r
    for j=1:r
        T = sqrt(( i - (r+1)/2 )^2 + ( j - (r+1)/2 )^2);
        CBOFmoder( i , j ) = exp(-T/gama_r);
    end
end

%����ͼ�����
switch (im_num)
    case 1
        %��������Ӳ�ֵ
        disp_max=15;
        %�����Ӳ�ͼ�Ŵ����
        scale=16;
        %��ȡͼ���
        iml_rgb=double(imread('atum\1\dataset\tsukuba\im2.ppm'))/255;
        imr_rgb=double(imread('datum\1\dataset\tsukuba\im6.ppm'))/255;
        %��ȡ��ʵ�Ӳ�ͼ
        im_disp_true=imread('datum\1\dataset\tsukuba\disp2.pgm');
        %��ȡ���۷�Χͼ
        im_eva_all=imread('datum\1\dataset\tsukuba\all.png');
    case 2
        %��������Ӳ�ֵ
        disp_max=32;
        %�����Ӳ�ͼ�Ŵ����
        scale=8;
        %��ȡͼ���
        iml_rgb=double(imread('datum\1\dataset\venus\im2.ppm'))/255;
        imr_rgb=double(imread('datum\1\dataset\venus\im6.ppm'))/255;
        %��ȡ��ʵ�Ӳ�ͼ
        im_disp_true=imread('datum\1\dataset\venus\disp2.pgm');
        %��ȡ���۷�Χͼ
        im_eva_all=imread('datum\1\dataset\venus\all.png');
    case 3
        %��������Ӳ�ֵ
        disp_max=59;
        %�����Ӳ�ͼ�Ŵ����
        scale=4;
        %��ȡͼ���
        iml_rgb=double(imread('datum\1\dataset\teddy\im2.ppm'))/255;
        imr_rgb=double(imread('datum\1\dataset\teddy\im6.ppm'))/255;
        %��ȡ��ʵ�Ӳ�ͼ
        im_disp_true=imread('datum\1\dataset\teddy\disp2.pgm');
        %��ȡ���۷�Χͼ
        im_eva_all=imread('datum\1\dataset\teddy\nonocc.png');
    case 4
        %��������Ӳ�ֵ
        disp_max=59;
        %�����Ӳ�ͼ�Ŵ����
        scale=4;
        %��ȡͼ���
        iml_rgb=double(imread('datum\1\dataset\cones\im2.ppm'))/255;
        imr_rgb=double(imread('datum\1\dataset\cones\im6.ppm'))/255;
        %��ȡ��ʵ�Ӳ�ͼ
        im_disp_true=imread('datum\1\dataset\cones\disp2.pgm');
        %��ȡ���۷�Χͼ
        im_eva_all=imread('datum\1\dataset\cones\nonocc.png');
 end
%��rgbͼ��ת��Ϊ�Ҷ�ͼ��
iml_gray=rgb2gray(iml_rgb);
imr_gray=rgb2gray(imr_rgb);
%��ȡͼ��ߴ�
[im_h,im_w,~]=size(iml_rgb);

%����rgbͼ����
iml_rgb_mirror=flipdim(iml_rgb,2);
imr_rgb_mirror=flipdim(imr_rgb,2);
%����Ҷ�ͼ��x�����ݶ�ͼ��
iml_gray_grad_x=gradient(iml_gray);
imr_gray_grad_x=gradient(imr_gray);
%�����ݶ�ͼ����
iml_gray_grad_x_mirror=flipdim(iml_gray_grad_x,2);
imr_gray_grad_x_mirror=flipdim(imr_gray_grad_x,2);
%�����ʼCostVolume
% cost_volume_l=ones(im_h,im_w,disp_max);
% cost_volume_r=ones(im_h,im_w,disp_max);
cost_volume_l=ones(im_h,im_w,disp_max)*cost_border;
cost_volume_r=ones(im_h,im_w,disp_max)*cost_border;
for d=1:disp_max
    %��ͼ
    imr_rgb_shift=[ones(im_h,d,3) imr_rgb(:,1:im_w-d,:)];
    color_diff=sum(abs(iml_rgb-imr_rgb_shift),3)/3;   
    imr_gray_grad_x_shift=[ones(im_h,d) imr_gray_grad_x(:,1:im_w-d)];
    grad_diff=abs(iml_gray_grad_x-imr_gray_grad_x_shift);
    cost_volume_l(:,:,d)=(1-alpha_grad).*min(color_diff,thres_color)+alpha_grad.*min(grad_diff,thres_grad);
    %��ͼ
    iml_rgb_mirror_shift=[ones(im_h,d,3) iml_rgb_mirror(:,1:im_w-d,:)];
    color_diff=sum(abs(imr_rgb_mirror-iml_rgb_mirror_shift),3)/3;   
    iml_gray_grad_x_mirror_shift=[ones(im_h,d) iml_gray_grad_x_mirror(:,1:im_w-d)];
    grad_diff=abs(imr_gray_grad_x_mirror-iml_gray_grad_x_mirror_shift);
    cost_volume_r(:,:,d)=flipdim((1-alpha_grad).*min(color_diff,thres_color)+alpha_grad.*min(grad_diff,thres_grad),2);          
end
clear iml_gray imr_gray iml_rgb_mirror iml_gray_grad_x imr_gray_grad_x iml_gray_grad_x_mirror imr_gray_grad_x_mirror;
clear imr_rgb_shift iml_rgb_mirror_shift color_diff imr_gray_grad_x_shift iml_gray_grad_x_mirror_shift grad_diff;

%�����˲����۾ۺ�


% 1������gf
cost_volume_l_1=cost_volume_l;
for d=1:disp_max
    cost_volume_temp=imcomplete_guidedfilter_color(iml_rgb(:,d+1:im_w,:),cost_volume_l(:,d+1:im_w,d),win_radius,epsilon);
    cost_volume_l_1(:,d+1:im_w,d)=cost_volume_temp;
end
figure(4);set(gcf, 'position',[200 200 1200 600])
[~,im_disp_l_gf_1]=min(cost_volume_l_1,[],3);
im_disp_l_gf_1=uint8(im_disp_l_gf_1.*scale);
imshow(im_disp_l_gf_1);


%2������gf+qһά����
cost_volume_l_3=cost_volume_l;
for d=1:disp_max
    cost_volume_temp=Copy_of_guidedfilter_color(iml_rgb(:,d+1:im_w,:),cost_volume_l(:,d+1:im_w,d),win_radius,epsilon);
    cost_volume_l_3(:,d+1:im_w,d)=cost_volume_temp;
end
figure(7);set(gcf, 'position',[200 200 1200 600])
[~,im_disp_l_gf_3]=min(cost_volume_l_3,[],3);
im_disp_l_gf_3=uint8(im_disp_l_gf_3.*scale);
imshow(im_disp_l_gf_3);

clear cost_volume_temp imr_rgb_mirror;

figure(10);set(gcf, 'position',[200 200 1200 600])
[~,im_disp_l_gf]=min(cost_volume_l,[],3);
im_disp_l_gf=uint8(im_disp_l_gf.*scale);
imshow(im_disp_l_gf);


%������ƥ��㣬�Ͷ�Ӧ���ֵ
im_disp_error1_l_1=bitor(abs(double(im_disp_true)-double(im_disp_l_gf_1))<=(1*scale),im_eva_all==0);
im_disp_error1_l_1=uint8(im_disp_error1_l_1);
error_rate1_l_1=sum(sum(im_disp_error1_l_1==0))/sum(sum(im_eva_all==1));

im_disp_error1_l_3=bitor(abs(double(im_disp_true)-double(im_disp_l_gf_3))<=(1*scale),im_eva_all==0);
im_disp_error1_l_3=uint8(im_disp_error1_l_3);
error_rate1_l_3=sum(sum(im_disp_error1_l_3==0))/sum(sum(im_eva_all==1));


im_disp_error1_l=bitor(abs(double(im_disp_true)-double(im_disp_l_gf))<=(1*scale),im_eva_all==0);
im_disp_error1_l=uint8(im_disp_error1_l);
error_rate1_l=sum(sum(im_disp_error1_l==0))/sum(sum(im_eva_all==1));
     

    