function orientationArray = orientationFind(p1,p2)
    
    % Calculate the vector passing through the two points
    vector = p2 - p1;
    
    % Calculate the azimuth angle (in degrees)
    azimuth = atan2(vector(2), vector(1)) * 180 / pi;
    
    % Calculate the elevation angle (in degrees)
    elevation = atan2(vector(3), sqrt(vector(1)^2 + vector(2)^2)) * 180 / pi;
    
    % Calculate the roll angle (in degrees)
    roll = atan2(vector(3), vector(2)) * 180 / pi;
    
    orientationArray = [azimuth,elevation,roll];
    
end