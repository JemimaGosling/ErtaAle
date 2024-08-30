%%
load("ErtaAle_CSKsampleData_PCAcorrected.mat")
load("ErtaAle_sampleData_variance.mat")
%% Dataset details and formatting
% Specify dataset
SAR = pcaSAR;

% Specify baseline length (ie how many pre-eruption images are available)
nBaseline = 15;

% Size of data
[nRows, nCols, nImages] = size(SAR);
nPix = nRows*nCols;

% Reshape data
SARreshaped = reshape(SAR,[nPix nImages]);
SARreshaped(SARreshaped == 0) = NaN;

fileInfo        =   'ErtaAle_geotifs.txt';
fid1            =   fopen(fileInfo);
[celllist]      =   textscan(fid1,'%s');
tifs            =   cell2mat(celllist{1});
SARDates        =   tifs(:,5:12);
eruptionStart   =   '20170121';
infmt           =   'yyyyMMdd';
dates           =   datetime(SARDates, "InputFormat", infmt);
eruptStart      =   datetime(eruptionStart, "InputFormat", infmt);

%% CUSUM for single pixels
% Specify rows and columns for individual plot (example pixels from paper)
% progressing downflow and then a background pixel
row = ([1608 1451 1361 1082 742 287 1842]); 
col = ([1022 1248 1631 2559 3441 3930 2748]);

% Perform CUSUM calcs using function
[lowersum, uppersum, PCAts, stdpline] = cusumSingle(pcaSAR,15,row,col);

% Perform CUSUM calcs for non PCA corrected SAR for this timeseries
[~, ~, ts, ~] = cusumSingle(SAR,15,row,col);

%% CUSUM single pixel plots
% Load shapefiles
file = 'fullFlows.shp';
S = shaperead(file);
outline = makesymbolspec("Polygon",{'Default','EdgeColor','#Ff0000', 'FaceAlpha', 0,'LineWidth',1.5});

n = length(row);
a = [1:n]'; b = num2str(a);labels = cellstr(b);
c = parula(n+1);c2 = c([1,7],:);c=c(1:7,:);

figure(1);
imagesc(EA_var); colormap('gray');  clim([0 2]); axis image; 
colorbar; 
hold on
scatter(col, row,60,c,'filled');
mapshow(S, "SymbolSpec", outline);
text(col, row, labels);
title('Pixel locations')
axis image

figure(2)
subplot(1,2,1); title(gca,'PCA corrected time series');
plot(dates,PCAts([1,7],:),'-o','MarkerSize', 5, 'LineWidth', 1.5);
hold on
plot(dates,ts([1,7],:),'--o','MarkerSize', 5, 'LineWidth', 1.5,'HandleVisibility','off');
colororder(gca,c2);grid on
plot([eruptStart eruptStart], ylim, 'r--', 'LineWidth', 1.5);
legend(gca,'1','7','Eruption start');xtickangle(60)

subplot(1,2,2); title(gca,'CUSUM plot');
h=plot(dates, uppersum, 'o', 'MarkerSize', 5, 'LineWidth', 1.5);
hold on
h2=plot(dates, lowersum, 'o', 'LineWidth', 1.5, HandleVisibility='off');
yline(stdpline*2,'k--', 'LineWidth', 1.5)
yline(-stdpline*2,'k--', 'LineWidth', 1.5)
colororder(gca,c);grid on
plot([eruptStart eruptStart], [-10 90], 'r--', 'LineWidth', 1.5);
legend(gca,labels);xtickangle(60)

%% CUSUM for full area
% Each image contains numbers for each pixel corresponding to the number of
% days between the eruption start and the flow emplacement date estimated 
% by CUSUM upper/lower threshold being exceeded
[lowerImage, upperImage] = cusumArea(SAR, nBaseline,eruptionStart,SARDates);

%% CUSUM area plot
% To make background transparent
upperImage(upperImage==0)=NaN;
lowerImage(lowerImage==0)=NaN;
% Load shapefiles
file = 'fullFlows.shp';
S = shaperead(file);
outline = makesymbolspec("Polygon",{'Default','EdgeColor','#Ff0000', 'FaceAlpha', 0,'LineWidth',1.5});

figure(3)
h = imagesc(xclip_coord,yclip_coord,upperImage); 
set(h, 'AlphaData', ~isnan(upperImage))
colormap(gca,'parula')
c = colorbar;
axis image; set(gca, 'YDir','normal');
title(gca,'CUSUM upper and lower PCA')
hold on
g = imagesc(xclip_coord,yclip_coord,lowerImage); 
set(g, 'AlphaData', ~isnan(lowerImage))
mapshow(S, "SymbolSpec", outline);