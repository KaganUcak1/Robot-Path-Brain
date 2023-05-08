for tet = 1:length(tetSelected)
    fprintf("The teta angle %f   \n",tetSelected(tet));
    for ang = 1:length(angSelected)
        x = r*sind(angSelected(ang))*cosd(tetSelected(tet));
        y = r*sind(angSelected(ang))*sind(tetSelected(tet));
        z = r*cosd(angSelected(ang));
        line1 = [x y z];
        minDistance = 200;
        for point = 1:length(coord)
            teta2 = acos(dot(coord(:,point)',line1)/norm(coord(:,point))/norm(line1));
            distance = sin(teta2)*norm(coord(:,point));
            if distance<minDistance; minDistance = distance;end
        end
        if minDistance>1.3
            plot3([0 x],[0 y],[0 z],"ro-", "LineWidth",3);
        end
    end
end
