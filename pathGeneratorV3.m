function entryPoints = pathGeneratorV3(coordStruct,detailed)
    coord = [coordStruct.vessels,coordStruct.cortex];
    vesselLength = length(coordStruct.vessels);
    startPoint = [0 0 0];
    
    deltaTeta = 10; deltaAngle = 10;
    r = 60;
    angle = -90:deltaAngle:90;
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
            coordPos = 0;
            for point = 1:length(coord)
                teta2 = acos(dot(coord(:,point)',line1)/norm(coord(:,point))/norm(line1));
                distance = sin(teta2)*norm(coord(:,point));
                if distance<minDistance 
                    minDistance = distance;
                    if point>coordPos; coordPos = point;end
                end

                if distance<25
                    if point>coordPos; coordPos = point;end
                end
            end

            if coordPos>vesselLength
                thresholdLim = 30;
            else
                thresholdLim = 1.3;
            end

            if minDistance>thresholdLim
                tetSelected = [tetSelected teta(tet)];
                angSelected = [angSelected angle(ang)];
            end
        end
    end

    
    if detailed == "on"
        tetaDetailed = [];angDetailed = [];
        range1 = 3; deltaRange1 = 2;
        for i = 1:length(tetSelected)
            tet = tetSelected(i);
            ang = angSelected(i);
            for j = -range1:deltaRange1:range1
                tetaDetailed = [tetaDetailed, tet+j];
                angDetailed = [angDetailed, ang+j];
            end
        end
        
        tetSelected= []; angSelected= [];
        
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
                end
            end
        end
    end
    entryPoints = zeros(length(tetSelected),6);
    j = 1;
    for tet = tetSelected
        for ang = angSelected
            x = r*sind(ang)*cosd(tet);
            y = r*sind(ang)*sind(tet);
            z = r*cosd(ang);
            entryPoints(j,:) = [startPoint x y z];
            j = j+1;
        end
    end

end