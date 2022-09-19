# landseaice
Generate land/sea/ice masks from ETOPO1 or other data, for use in VLF radio propagation simulations.  Land, sea and ice have significantly different electrical permittivity and conductivity, leading to different reflection and attenuation of radio waves propagating between these surfaces and the ionosphere.

## Current version (September 19 2022)

1-degree latitude/longitude grid-registered land/sea/ice mask available in ````LSI_mask.mat````.  This version is built using the ETOPO1 Ice Surface altimetry file, which shows elevation of the ocean floor, land, and ice surface.  ETOPO1 elevation is downsampled to integer latitude and longitude, and grid points at or below sea level are assigned the value -1 in the mask, while points above sea level are assigned +1.  Ice cover is assigned the value 0, and is determined in two steps:

1. Any grid point above sea level and south of -60 degrees latitude is ice.
2. Any grid point inside the Greenland coastline, determined from ````coastlines.mat````, is ice.

There are several clear errors in this land-sea-ice mask.  In no particular order:

1. Seasonal sea ice is entirely missing.
2. Ice shelves in Antarctica may be undersized
3. Land areas below sea level (e.g. near the Caspian Sea, and in northern Africa and central Australia) are treated as sea.

The next version of the LSI mask may make more use of ````coastlines.mat```` polygons to ensure points inside coastlines are assigned land values, and points inside inland seas are assigned sea values.  ````coastlines.mat```` is included in the MATLAB Mapping Toolbox.

![1-degree land-sea-ice mask](https://github.com/andersontodds/landseaice/blob/main/lsi_ETOPO1_1deg.jpg?raw=true)
