%% cusumAREA: function to perform CUSUM calculations over an area
% Inputs: 
% SAR: image dataset as 3D array (a x b x c) with each page (c) as
%      an image of size a x b of the target area
% nBaseline: number of baseline images in the dataset (i.e. how many
%            pre-eruption images are available)
% eruptionStart: start date of the eruption as char variable YYYYMMDD
%                e.g. 20170121
% SARDates: image acquisition dates as char list YYYYMMDD

% Outputs:
% lowerImage: CUSUM lower image where each pixel is specified by a number 
%             corresponding to the number of days between the eruption 
%             start and the flow emplacement date estimated by CUSUM 
%             (background pixels or those undetected by CUSUM as NaN)
% upperImage: CUSUM lower image where each pixel is specified by a number 
%             corresponding to the number of days between the eruption 
%             start and the flow emplacement date estimated by CUSUM 
%             (background pixels or those undetected by CUSUM as NaN)

function [lowerImage, upperImage] = cusumArea(SAR,nBaseline,eruptionStart,SARDates)
    % Format dates
    infmt = 'yyyyMMdd';
    dates = datetime(SARDates, "InputFormat", infmt);
    eStart = datetime(eruptionStart, "InputFormat", infmt); % Convert to datetime
    % Calculate size of data
    [nRows, nCols, nImages] = size(SAR);
    nPix = nRows*nCols;
    % Reshape data
    SARreshaped = reshape(SAR,[nPix nImages]);
    SARreshaped(SARreshaped == 0) = NaN;
    % For each pixel
    for k = 1:nPix
        % Specify individual pixel time series
        TS = SARreshaped(k,:);
        % Replace NaN pixels in each pixels time series with mean post 
        % eruption value 
        if ~isnan(TS(1,1))
            for i = 1:nImages
                if isnan(TS(i))
                    TS(i) = mean(TS(nBaseline+1:nImages), "omitnan");
                end
                % If still NaN then replace with full image mean value
                if isnan(TS(i))
                    TS(i) = mean(SARreshaped,'all','omitnan');
                end
            end
        else
            % Otherwise the full time series is NaN to be skipped later
            TS = NaN(1,nImages);
        end
        % Double time series for CUSUM calculations to work
        TS = double(TS);
        % Calculate mean and standard deviation for the pre-eruption time
        % series for pixel-specific CUSUM detection limits
        m = mean(TS(:,1:nBaseline));
        s = std(TS(:,1:nBaseline));
        
        % Perform CUSUM calculations using matlab cusum function on non-NaN
        % non-zero pixels
        if ~isnan(SARreshaped(k,1)) && SARreshaped(k,1)>0
            [iupper, ilower, ~,~] = cusum(TS, 5, 2, m, s);
    
            if isempty(ilower)
                ilower = 0;
            end
            if isempty(iupper) 
                iupper = 0;
            end
    
            lower(k) = ilower;
            upper(k) = iupper;
        else 
            lower(k) = NaN;
            upper(k) = NaN;
        end
    end
    % Lower and upper are given as the image number where flow emplacement
    % first estimated by CUSUM i.e. when detection limits are exceeded
    
    % Convert this to number of days between the eruption start and that
    % image acquisition date
    matrixL = zeros(size(lower));
    matrixU = zeros(size(upper));
    for i = 1:nPix
        if lower(i) ~= 0 && ~isnan(lower(i))
            d = lower(i);
            matrixL(i) = days(dates(d) - eStart);
        else
            matrixL(i) = 0;
        end
    end
    for i = 1:nPix
        if upper(i) ~= 0 && ~isnan(upper(i))
            d = upper(i);
            matrixU(i) = days(dates(d) - eStart);
        else
            matrixU(i) = 0;
        end
    end

    % Reshape back into images 
    lowerImage = reshape(matrixL, nRows, nCols);
    lowerImage(lowerImage==0) = NaN;
    upperImage = reshape(matrixU, nRows, nCols);
    upperImage(upperImage==0) = NaN;
    end
