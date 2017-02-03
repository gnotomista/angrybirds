clc
clear
close all

load birdbreastbeakeyeseyebrow

figure
hold on
axis equal

Mx = max(x);
mx = min(x);
My = max(y);
my = min(y);
gx = (Mx+mx)/2;
gy = (My+my)/2;

x1 = [x(1:2); x1];
y1 = [y(1:2); y1];
x0Bird = x - gx;
x1Bird = x1 - gx;
x2Bird = x2 - gx;
x3Bird = x3 - gx;
x4Bird = x4 - gx;
x5Bird = x5;
x6Bird = x6;
y0Bird = -y + gy;
y1Bird = -y1 + gy;
y2Bird = -y2 + gy;
y3Bird = -y3 + gy;
y4Bird = -y4 + gy;
y5Bird = y5 + 2*gy/100;
y6Bird = y6 + 2*gy/100;

x0Bird = x0Bird/100;
x1Bird = x1Bird/100;
x2Bird = x2Bird/100;
x3Bird = x3Bird/100;
x4Bird = x4Bird/100;
y0Bird = y0Bird/100;
y1Bird = y1Bird/100;
y2Bird = y2Bird/100;
y3Bird = y3Bird/100;
y4Bird = y4Bird/100;

fill(x0Bird,y0Bird,[206 0 30]/255)
fill(x1Bird,y1Bird,[239 203 173]/255)
fill(x2Bird,y2Bird,[255 190 16]/255)
fill(x3Bird,y3Bird,[1 1 1])
fill(x4Bird,y4Bird,[0 0 0])
fill(x5Bird,y5Bird,[0 0 0])
fill(x6Bird,y6Bird,[0 0 0])

colorBird = {[206 0 30]/255, [239 203 173]/255, [255 190 16]/255, [1 1 1], [0 0 0], [0 0 0], [0 0 0]};

save bird x0Bird x1Bird x2Bird x3Bird x4Bird x5Bird x6Bird y0Bird y1Bird y2Bird y3Bird y4Bird y5Bird y6Bird colorBird




