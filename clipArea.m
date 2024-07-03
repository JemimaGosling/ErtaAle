%% clipArea: function to clip area of dataset
% Inputs: 3D array of data (logged geotifs),y_coord, x_coord, log_geotif, 
% cornerlat, cornerlon,postlat,postlon, coordinates to clip to specified as
% rows and columns (R1,R2,C1,C2) 
% Outputs: clipped 3D array of data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [clipBackscat, yclip_coord, xclip_coord] = clipArea(log_geotif,cornerlat,cornerlon,postlat,postlon,R1,R2,C1,C2)
    % Clip backscatter data to area
    clipBackscat = log_geotif(R1:R2,C1:C2,:);
    
    % Calculate new x and y coordinates for clipped section
    line_clip   =   (C2-C1)+1;
    width_clip  =   (R2-R1)+1;
    
    cornerlat_clip  =   cornerlat+(R1-1)*postlat;
    cornerlon_clip  =   cornerlon+(C1-1)*postlon;
    
    yclip_coord      =   cornerlat_clip:postlat:(width_clip-1)*postlat+cornerlat_clip;
    xclip_coord      =   cornerlon_clip:postlon:(line_clip-1)*postlon+cornerlon_clip;
end