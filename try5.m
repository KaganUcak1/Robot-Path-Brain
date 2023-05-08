
data = load("primary_motor_cortex.mat"); 
down10 = data.vrt_10;

figure
plot3(coord(1,:),coord(2,:),coord(3,:),"r*","LineWidth",4); hold on;
scale = 1000;

zAngle = 30;
zAxisRotation = [cosd(zAngle) -sind(zAngle) 0
                 sind(zAngle)  cosd(zAngle) 0
                 0              0           1];
zAdjust = -20;

down10 = down10*scale;
down10 = down10*zAxisRotation;
down10(:,3) = down10(:,3)+zAdjust;

plot3(down10(:,1),down10(:,2),down10(:,3), "b*","LineWidth",4);
axis equal