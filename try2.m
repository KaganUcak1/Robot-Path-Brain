% clc; clear
% figure
% gm = importGeometry("brainSimpleModel v2.stl");
% pdegplot(gm)
% hold on;
% plot3(gm.Vertices(:,1),gm.Vertices(:,2),gm.Vertices(:,3), "r*")
clc
model = createpde(1);
importGeometry(model,"pseudo_skull_v2.stl");
meshFile = generateMesh(model,"Hmax",4);
figure
pdeplot3D(model); hold on

coord = meshFile.Nodes;
plot3(coord(1,1:1000),coord(2,1:1000),coord(3,1:1000),"r*")

deltaTeta = 1; deltaAngle = 1;
angle = -90:deltaAngle:90;
r = 60:80;
teta = -90:deltaTeta:90;
minDistanceArray = [];
for tet = 1:length(teta)
    for ang = 1:length(angle)
        x = r*sind(angle(ang))*cosd(teta(tet));
        y = r*sind(angle(ang))*sind(teta(tet));
        z = r*cosd(angle(ang));
        minDistance = 150;
        for i = 1:length(x)
            tempCoords = coord-[x(i);y(i);z(i)];
            normTempCoords = sqrt(tempCoords(1,:).^2 + tempCoords(2,:).^2 + tempCoords(3,:).^2);
            if minDistance > min(normTempCoords); minDistance = min(normTempCoords); end
        end
        minDistanceArray = [minDistanceArray; minDistance];
        if minDistance>1.3;    plot3(x,y,z,"ko-");end
    end
end
