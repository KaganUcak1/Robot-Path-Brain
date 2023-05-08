clc; clear;
close all
model = createpde(1);
importGeometry(model,"Stroke Vessels FINAL.stl");
meshFile = generateMesh(model,"Hmax",4);
coord = meshFile.Nodes;
centerOfmesh = [0 0 0];
centerOfmesh(1) = sum(coord(1,:))/length(coord);
centerOfmesh(2) = sum(coord(2,:))/length(coord);
centerOfmesh(3) = sum(coord(3,:))/length(coord);


coord = [coord(3,:)-centerOfmesh(3);
         coord(2,:)-centerOfmesh(2);
         -coord(1,:)+centerOfmesh(1)];

model2 = createpde(1);
geometryFromMesh(model2,coord,meshFile.Elements);
meshFile2 = generateMesh(model2,"Hmax",10);

center_of_paths = [0 0 0];

figure
pdeplot3D(model2); hold on

deltaTeta = 10; deltaAngle = 10;

r = 45;
angle = 90:deltaAngle:270;
teta = 0:deltaTeta:300;
minDistanceArray = [];
tetSelected = []; angSelected = [];
for tet = 1:length(teta)
    fprintf("The teta angle %f   \n",teta(tet));
    for ang = 1:length(angle)
        x = r*sind(angle(ang))*cosd(teta(tet));
        y = r*sind(angle(ang))*sind(teta(tet));
        z = r*cosd(angle(ang));
        line1 = [x y z];
        minDistance = 200;
        for point = 1:length(coord)
            teta2 = acos(dot(coord(:,point)',line1)/norm(coord(:,point))/norm(line1));
            distance = sin(teta2)*norm(coord(:,point));
            if distance<minDistance; minDistance = distance;end
        end
        if minDistance>1.3
            tetSelected = [tetSelected teta(tet)];
            angSelected = [angSelected angle(ang)];
            plot3([0 x],[0 y],[0 z],"k-", "LineWidth",2);
        end
    end
end

tetaDetailed = [];angDetailed = [];
range1 = 3; deltaRange1 = 3;
for i = 1:length(tetSelected)
    tet = tetSelected(i);
    ang = angSelected(i);
    for j = -range1:deltaRange1:range1
        tetaDetailed = [tetaDetailed, tet+j];
        angDetailed = [angDetailed, ang+j];
    end
end


for tet = 1:length(tetaDetailed)
    fprintf("The teta angle %f   \n",tetaDetailed(tet));
    for ang = 1:length(angDetailed)
        x = r*sind(angDetailed(ang))*cosd(tetaDetailed(tet));
        y = r*sind(angDetailed(ang))*sind(tetaDetailed(tet));
        z = r*cosd(angDetailed(ang));
        line1 = [x y z];
        minDistance = 200;
        for point = 1:length(coord)
            teta2 = acos(dot(coord(:,point)',line1)/norm(coord(:,point))/norm(line1));
            distance = sin(teta2)*norm(coord(:,point));
            if distance<minDistance; minDistance = distance;end
        end
        if minDistance>1.3
            tetSelected = [tetSelected tetaDetailed(tet)];
            angSelected = [angSelected angDetailed(ang)];
            plot3([0 x],[0 y],[0 z],"k-", "LineWidth",2);
        end
    end
end
