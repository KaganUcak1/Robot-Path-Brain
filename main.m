%% Main code
clc; clear

str1 = "vessels.stl";
str1_2 = "pseudo_skull_v2.stl";
str2 = "primary_motor_cortex.mat";

obstacleCoords = loadData(str1, str2);

start_and_entry_points  = pathGeneratorV3(obstacleCoords,"off");

figure
plot3(obstacleCoords.vessels(1,:),obstacleCoords.vessels(2,:),obstacleCoords.vessels(3,:),"r*","LineWidth",4);axis equal; grid on; hold on
plot3(obstacleCoords.cortex(1,:),obstacleCoords.cortex(2,:),obstacleCoords.cortex(3,:),"b*","LineWidth",4);
for i = 1:length(start_and_entry_points)
    plot3(start_and_entry_points(i,[1 4]),start_and_entry_points(i,[2 5]),start_and_entry_points(i,[3 6]),"ko-","LineWidth",2)
end

point1_2 = [-243.17 -461.47 60.92 ];
point2_2 = [-277.97 -523.03 61.63 ];
point3_2 = [-129.90 -525.75 60.78 ];
point4_2 = [-164.04 -586.37 60.84 ];
point5_2 = [-202.74 -524.21 100.66];

global_points = [point2_2;point1_2;point5_2];

%pointTouch = [22.5000  0  -38.9711];
pointTouch = start_and_entry_points(5,:);

resultMatrix =  registration(global_points,pointTouch)

