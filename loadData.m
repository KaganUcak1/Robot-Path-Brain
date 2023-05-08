%% to load stl data
function obstacleCoords = loadData(str, str2)
    model = createpde(1);
    importGeometry(model,str);
    geo = model.Geometry;
    coord = geo.Vertices;
    coord = coord';
    centerOfmesh = [0 0 0];
    centerOfmesh(1) = sum(coord(1,:))/length(coord);
    centerOfmesh(2) = sum(coord(2,:))/length(coord);
    centerOfmesh(3) = sum(coord(3,:))/length(coord);
    
    coord = [coord(1,:)-centerOfmesh(1);
        coord(2,:)-centerOfmesh(2);
        coord(3,:)-centerOfmesh(3)];    


    data = load(str2); 
    down10 = data.vrt_10;
    
    figure
    plot3(coord(1,:),coord(2,:),coord(3,:),"r*","LineWidth",4); hold on;
    scale = 1000;
    
    zAngle = 30;
    zAxisRotation = [cosd(zAngle) -sind(zAngle) 0
                     sind(zAngle)  cosd(zAngle) 0
                     0              0           1];
    zAdjust = -20;
    
    down10 = down10*scale*zAxisRotation;
    down10(:,3) = down10(:,3)+zAdjust;
    
    plot3(down10(:,1),down10(:,2),down10(:,3), "b*","LineWidth",4);
    axis equal; grid on

    obstacleCoords = struct;
    obstacleCoords.vessels = coord;
    obstacleCoords.cortex = down10';
end