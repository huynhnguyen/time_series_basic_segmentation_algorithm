sample = csvread('seg_sample.csv');
plot(sample);
%segmentation check for bottomUp
figure();
seg_bottomUp(sample,8,1);
%segmentation check for topDown
figure();
seg_topDown(sample,8,1);
%segmentation check for swab
