% LoadLogGeotifs: loads geotif backscatter data, calculate and define axes,
% performs 10*log10 calculation on data to convert them to dB (logarithmic 
% greyscale which allows more contrast to view images) 

% Inputs: geotif string file name (geotif)
% Outputs: xcoord, ycoord (specify coordinates for plotting images in
% figures) and log_geotifs (

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y_coord, x_coord, log_geotif, cornerlat,cornerlon,postlat,postlon] = LoadLogGeotifs(geotif)

    [Backscatter,Coordinates]   =   readgeoraster(geotif); 
    
    Backscatter(Backscatter==0) = NaN; Backscatter(Backscatter<1) = NaN; 
    
    width_whole     =   Coordinates.RasterSize(2);
    line_whole      =   Coordinates.RasterSize(1);
    
    cornerlat       =   Coordinates.LatitudeLimits(2);
    cornerlon       =   Coordinates.LongitudeLimits(1);
    
    postlat         =   -Coordinates.SampleSpacingInLatitude;
    postlon         =   Coordinates.SampleSpacingInLongitude;
    
    y_coord               =   cornerlat:postlat:(line_whole-1)*postlat+cornerlat;
    x_coord               =   cornerlon:postlon:(width_whole-1)*postlon+cornerlon;

    log_geotif = 10.*log10(Backscatter);
end
