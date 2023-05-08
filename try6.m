% Define the coordinates of point 1 and point 2
point1 = [0 0 0]; % Replace x1, y1, z1 with the actual coordinates of point 1
point2 = [1 0 0]; % Replace x2, y2, z2 with the actual coordinates of point 2

% Calculate the direction vector
direction_vector = point2 - point1;

% Extract the x, y, and z components of the direction vector
dx = direction_vector(1);
dy = direction_vector(2);
dz = direction_vector(3);

% Calculate the yaw angle (rotation around the z-axis)
yaw = atan2(dy, dx);

% Calculate the pitch angle (rotation around the x-axis)
pitch = atan2(dz, sqrt(dx^2 + dy^2));

% Calculate the roll angle (rotation around the y-axis)
roll = atan2(dx, dy);

% Convert the angles from radians to degrees if desired
yaw_deg = rad2deg(yaw);
pitch_deg = rad2deg(pitch);
roll_deg = rad2deg(roll);

% Display the orientation angles
disp(['Yaw angle: ', num2str(yaw_deg), ' degrees']);
disp(['Pitch angle: ', num2str(pitch_deg), ' degrees']);
disp(['Roll angle: ', num2str(roll_deg), ' degrees']);
