Version 1.0 

# two-state-poisson
This code was used to produce the results published in

Selva J, Sandri L, Taroni M, Sulpizio R, Tierz P, Costa A (2022), A simple two-state model interprets temporal modulations in eruptive activity and enhances multivolcano hazard quantification.Sci. Adv.8, eabq4415(2022).DOI:10.1126/sciadv.abq4415

To code should be run is in Matlab by lunching the script BiRates. The output files are stored in folder "OutputFiles".

The input files for Mt. Vesuvius, Campi Flegrei and Ischia are provided. The input file is a txt file. The first three lines report general information like

XXX 	% end year of the catalog 

XXX 	% length of the catalog in years

XXX	  % number of clusters

The following lines report the information relative to each cluster. The following four lines should be reported for each cluster:

XXX	  % Cluster 1: year of the first eruption 

XXX	  % Cluster 1: length in years (from first to last eruption) of cluster 1 

XXX	  % Cluster 1: use to compute lambdaH (Y/N)

XXX	  % Cluster 1: total number of eruption (inclusing starting eruption) 

If "N" is reported in line 3, the number reported in line 4 is ignored.



