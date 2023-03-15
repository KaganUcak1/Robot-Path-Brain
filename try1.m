x = [1 2 3 4 5 5.5 7 8 9 9.5 10];
y = [0 0 0 0.5 0.4 1.2 1.2 0.1 0 0.3 0.6];
xq = 0.75:0.05:10.25;
yqs = spline(x,y,xq);
yqp = pchip(x,y,xq);
yqm = makima(x,y,xq);

plot(x,y,'ko','LineWidth',2,'MarkerSize',10)
hold on
plot(xq,yqp,'LineWidth',4)
plot(xq,yqs,xq,yqm,'LineWidth',2)
legend('(x,y) data','pchip','spline','makima')
