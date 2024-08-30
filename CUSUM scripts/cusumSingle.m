%% cusumSingle: function to perform CUSUM calculations on a single pixel
% Inputs: 
% SAR: image dataset as 3D array (a x b x c) with each page (c) as
%      an image of size a x b of the target area
% nBaseline: number of baseline images in the dataset (ie how many
%            pre-eruption images are available)
% row: pixel row numbers of target pixels e.g.[10, 20, 30, ...]
% columns: pixel column numbers of target pixels e.g.[10, 20, 30, ...]

% Outputs:
% lowersum: CUSUM lower sum values for each pixel specified by row, col
% uppersum: CUSUM upper sum values for each pixel specified by row, col
% ts: time series of SAR data 
function [lowersum, uppersum, ts, stdpline] = cusumSingle(SAR,nBaseline,row,col)
    climit = 5; mshift = 2;
    n = length(row);
    for i = 1:n 
        ts(i,:) = squeeze(SAR(row(i),col(i),:));
        timeSeries = double(ts(i,:));
        meanpline = mean(timeSeries(1:nBaseline));
        stdpline = std(timeSeries(1:nBaseline));
        [~,~,uppersum(:,i),lowersum(:,i)] = cusum(timeSeries, climit,mshift,meanpline,stdpline);
    end
end
