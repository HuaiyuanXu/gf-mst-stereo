function w_oc_total=w_oc_calcu(I_q_total,I_p,step,glcm_0,glcm_45,glcm_90,glcm_135,glcm_180,glcm_225,glcm_270,glcm_315)
w_oc_total=I_q_total;
for i=0:step-1
    w_oc_total(i*8+1,1)=glcm_0(I_p,I_q_total(i*8+1,1),i+1);
    w_oc_total(i*8+2,1)=glcm_45(I_p,I_q_total(i*8+2,1),i+1);
    w_oc_total(i*8+3,1)=glcm_90(I_p,I_q_total(i*8+3,1),i+1);
    w_oc_total(i*8+4,1)=glcm_135(I_p,I_q_total(i*8+4,1),i+1);
    w_oc_total(i*8+5,1)=glcm_180(I_p,I_q_total(i*8+5,1),i+1);
    w_oc_total(i*8+6,1)=glcm_225(I_p,I_q_total(i*8+6,1),i+1);
    w_oc_total(i*8+7,1)=glcm_270(I_p,I_q_total(i*8+7,1),i+1);
    w_oc_total(i*8+8,1)=glcm_315(I_p,I_q_total(i*8+8,1),i+1);
end
