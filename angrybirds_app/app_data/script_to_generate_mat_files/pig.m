clc
clear
close all

load pigoutsidenoseeyesnoseeyes

figure
hold on
axis equal

Mx = max(x);
mx = min(x);
My = max(y);
my = min(y);
gx = (Mx+mx)/2;
gy = (My+my)/2;

x0Pig = x - gx;
x1Pig = x1 - gx;
x2Pig = x2 - gx;
x3Pig = x3 - gx;
x4Pig = x4 - gx;
x5Pig = x5 - gx;
x6Pig = x6 - gx;
x7Pig = x7 - gx;
y0Pig = y - gy;
y1Pig = y1 - gy;
y2Pig = y2 - gy;
y3Pig = y3 - gy;
y4Pig = y4 - gy;
y5Pig = y5 - gy;
y6Pig = y6 - gy;
y7Pig = y7 - gy;

x0Pig = x0Pig/100;
x1Pig = x1Pig/100;
x2Pig = x2Pig/100;
x3Pig = x3Pig/100;
x4Pig = x4Pig/100;
x5Pig = x5Pig/100;
x6Pig = x6Pig/100;
x7Pig = x7Pig/100;
y0Pig = y0Pig/100;
y1Pig = y1Pig/100;
y2Pig = y2Pig/100;
y3Pig = y3Pig/100;
y4Pig = y4Pig/100;
y5Pig = y5Pig/100;
y6Pig = y6Pig/100;
y7Pig = y7Pig/100;

fill(x0Pig,y0Pig,[99 239 66]/255)
fill(x1Pig,y1Pig,[165 239 0]/255)
fill(x2Pig,y2Pig,[1 1 1])
fill(x3Pig,y3Pig,[1 1 1])
fill(x4Pig,y4Pig,[0 0 0])
fill(x5Pig,y5Pig,[0 0 0])
fill(x6Pig,y6Pig,[0 0 0])
fill(x7Pig,y7Pig,[0 0 0])

colorPig = {[99 239 66]/255, [165 239 0]/255, [1 1 1], [1 1 1], [0 0 0], [0 0 0], [0 0 0], [0 0 0]};

save pig x0Pig x1Pig x2Pig x3Pig x4Pig x5Pig x6Pig x7Pig y0Pig y1Pig y2Pig y3Pig y4Pig y5Pig y6Pig y7Pig colorPig




