# landseaice
Generate land/sea/ice masks from ETOPO1 or other data, for use in VLF radio propagation simulations.  Land, sea and ice have significantly different electrical permittivity and conductivity, leading to different reflection and attenuation of radio waves propagating between these surfaces and the ionosphere.

## Current version (September 21 2022)

1-degree latitude/longitude grid-registered land/sea/ice mask available in ````LSI_mask.mat````.  This version is built using the MATLAB Mapping Toolbox's ````coastlines.mat```` file, as well as the ETOPO1 Ice Surface altimetry file.  First, points on a 1-degree lat-lon mesh are checked for whether they are inside any coastline polygon with more than 15 vertices.  All points inside these coastline polygons are assigned +1, and points outside coastlines are assigned -1.  Because polygons can have interior edges, this method is able to identify inland seas.  Ice cover is assigned the value 0, and determined from positive ETOPO1 elevation south of -60 degrees latitude (Antarctica + ice shelves), and the interior of the Greenland coastline polygon.  ETOPO1 elevation is downsampled to integer latitude and longitude to match the lat-lon mesh.

Although this mask is an improvement on the previous version, there are still several clear errors:

1. Seasonal sea ice is entirely missing
2. Ice shelves in Antarctica may be undersized
3. All bodies of water (of sufficient size) are assigned the same mask value

The next version of this mask will need to incorporate seasonal ice extent data.

![1-degree land-sea-ice mask](https://github.com/andersontodds/landseaice/blob/main/lsi_ETOPO1_poly_1deg.jpg?raw=true)
