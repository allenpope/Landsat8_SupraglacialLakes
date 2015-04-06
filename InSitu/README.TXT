References:
See Pope et al. (The Cryosphere) for results and Pope et al. (Computers and Geosciences)
for methods, data, and provenance. WorldView-2 results are presented in Moussavi et al
(Remote Sensing of Environment).


Data Citation: Tedesco, M., N. Steiner, and A. Pope (2015): In situ spectral reflectance and depth of a supraglacial lake in Greenland. UCAR/NCAR - CISL - ACADIS. Dataset. http://dx.doi.org/10.5065/D6FQ9TN2

See data contained in (and associated README):
*boat_spectral_data.mat
*relative_spectral_responses.mat
*convolved_spectra.mat
*single_band_regression_stats.mat
*two_band_regression_stats.mat


Start with: boat_spectral_data.mat

First: Depth_for_regression_bit_calcs.m
     extracts depth from the boat_spectral structure

Second: Lake_spectra_processing_bit_calcs.m
     Calculated resolution of spectra
     Creates space in structures for convolved spectra
     Takes in above output and relative_spectral_responses.mat
     Outputs appropriate convolved spectra

Third: Lake_spectra_regression_bit_calcs.m
     Prepares data for the single band regressions
     Then Regresses depths and convolved spectra to emulate single-band
     	satellite lake depth retrievals for a range of sensors.
     These data are the output in single_band_regression_stats.mat

Fourth: method2.m & method2_wv2_revised.m
     Regresses depths and convolved spectra to emulate band-ratio
     satellite lake depth retrievals for a range of sensors. A wider
     investigation of WorldView-2 bands (see Moussavi et al., 2015 - RSE)
     is conducted with the second script. All data are stored in
     two_band_regression_stats.mat

Fifth: Figure2_code.m
     Uses the data outputted above to plot the components of Figure 2 in Pope et al., 2015
