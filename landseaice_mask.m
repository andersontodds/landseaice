% landseaice_mask.m
% Todd Anderson
% 19 September 2022
%
% Generate whole-Earth land-sea-ice mask for use with VLF propagation.

%% Read downsampled ETOPO1 NC data
% File: ETOPO1 ice surface topography, grid-registered, GMT4, from NOAA NGDC:
ncURL = "https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/";
ncfile = "ETOPO1_Ice_g_gmt4.grd";

loninfo = ncinfo(ncfile, "x");
latinfo = ncinfo(ncfile, "y");
altinfo = ncinfo(ncfile, "z");

dec_factor = 60; % data decimation factor

lon = ncread(ncfile, "x", 1, floor(loninfo.Size/dec_factor)+1, dec_factor);
lat = ncread(ncfile, "y", 1, floor(latinfo.Size/dec_factor)+1, dec_factor);

alt_start = [1, 1];
alt_count = [floor(altinfo.Size(1)/dec_factor)+1, floor(altinfo.Size(2)/dec_factor)+1];
alt_stride = [dec_factor, dec_factor];

alt = ncread(ncfile, "z", alt_start, alt_count, alt_stride);
alt = alt';

[lonmesh, latmesh] = meshgrid(lon, lat);

%% check for land, sea and ice
lsi = zeros(size(alt));
lsi(alt <= 0) = -1; % sea
lsi(alt > 0) = 1;   % land
lsi(lsi==1 & latmesh < -60) = 0; % ice: antarctica including ice shelves

% get Antarctica and Greenland coastline polygons from coastlines.mat
load coastlines;
cl_ant = 1:739;
cl_grl = 3977:4210;

% check if geographic points are inside polygon
in_ant = inpolygon(lonmesh(:), latmesh(:), coastlon(cl_ant), coastlat(cl_ant));
in_grl = inpolygon(lonmesh(:), latmesh(:), coastlon(cl_grl), coastlat(cl_grl));
lsi(in_ant | in_grl) = 0;

%% save land-sea-ice mask
mask = struct("lat_mesh", latmesh, ...
    "lon_mesh", lonmesh, ...
    "LSI", lsi, ...
    "ETOPO1_filename", ncfile, ...
    "File_URL", ncURL);

% save("LSI_mask.mat", "mask");
save("LSI_mask_vars.mat", "latmesh", "lonmesh", "lsi", "ncfile", "ncURL");

%% plot

figure(1)
hold off
worldmap("World");
geoshow(latmesh, lonmesh, alt, "DisplayType", "texturemap");
hold on
geoshow(coastlat, coastlon, "color", "black");

c1 = colorbar();
%caxis([-10000 10000]);
crameri('bukavu', 'pivot', 0);
c1.Label.String = "elevation (m)";

figure(2)
hold off
worldmap("World");
geoshow(latmesh, lonmesh, lsi, "DisplayType", "texturemap");
hold on
geoshow(coastlat, coastlon, "color", "black");

c1 = colorbar();
caxis([-2 2]);
c1.Ticks = [-1, 0, 1];
c1.TickLabels = {'sea','ice','land'};
crameri('broc', 'pivot', 0);
%c1.Label.String = "land-sea-ice mask";

title("1-degree Land-Sea-Ice mask based on ETOPO1 elevation")
