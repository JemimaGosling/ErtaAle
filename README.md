# Introduction

SAR backscatter lava flow processing, analysis and detection for the 2017 Erta 'Ale lava flows. The method development and analysis are detailed fully in [Gosling et al., (Submitted)](https://www.researchsquare.com/article/rs-5003481/v1). This github contains:  
- **Manual flow boundaries:** Shapefiles contain the manually extracted flow maps for the individual SAR backscatter images.
- **CUSUM scripts:** Main script (_ErtaAle_sample_code.m_) allows for recreation of processing and analysis shown in published paper. It allows user to load in pre-processed (multi-looked, radiometric terrain corrected and geocoded) CSK SAR backscatter images over Erta 'Ale, run further processing and the described automated flow extraction on individual pixels (_cusumSingle.m_) and for wider areas (_cusumArea.m_)
- **Functions:** Additional functions needed to run demo script (_ErtaAle_sample_code.m_)
- **sample data:** MatLAB variables that contain the multi-looked, radiometric terrain corrected and geocoded CSK backscatter images (_ErtaAle_CSKsampleData_PCAcorrected.mat_) and the variance map for the whole dataset (_ErtaAle_sampleData_variance.mat_). A list of all geotiff used to create these variable can be found in _ErtaAle_geotifs.txt_ and all the figures created when running the main script.

# Running scripts
These are MATLAB script. The main script (_ErtaAle_sample_code.m_) in CUSUM script does the following: 
- Loads in pre-processed SAR backscatter images and variance dataset.
- The number of SAR images used for the CUSUM baseline is defined on **Line 13**
- Constructs data matrix and date list used in analysis
- Runs CUSUM on individual pixels using the _cusumSingle.m_ script. The pixels are determined manually selected by user on **lines 41 and 42**.
- This section produces the two following figures (that were used to create Fig. 5 in paper):

![Figure1](https://github.com/JemimaGosling/ErtaAle/blob/main/sample%20data/DEMO_Figure_1.png)
**Figure showing pixel location on the variance dataset**

![Figure2](https://github.com/JemimaGosling/ErtaAle/blob/main/sample%20data/DEMO_Figure_2.png)
**Individual pixel timeseries (panel 1) for two of the manually chosen pixels (Line 71 allows for changing which pixels are plotted) and the CUSUM chart (panel 2) showing upper and lower cumulative sums of deviations above CUSUMs detection thresholds for chosen pixels**

- Next it runs CUSUM on the whole dataset. This creates the figure showing all CUSUM deviations and the number of image that change occured on. 
![Figure3](https://github.com/JemimaGosling/ErtaAle/blob/main/sample%20data/DEMO_Figure_3.png)
