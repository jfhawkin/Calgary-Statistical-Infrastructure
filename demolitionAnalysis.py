# -*- coding: utf-8 -*-
"""
Created on Mon Jan 23 14:40:03 2017

@author: jason
"""
import shapefile
import numpy as np
from sklearn.cluster import DBSCAN
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
from cartopy.io.img_tiles import OSM

osm_tiles = OSM()
proj = osm_tiles.crs

sf = shapefile.Reader("../GIS/Demolitions_3857.shp")
shapes = sf.shapes()
coord = []
for shape in shapes:
    try:
        if shape.points[0][0]< -1.26*10**7 and shape.points[0][0]> -1.274*10**7 and shape.points[0][1]< 6.67*10**6 and shape.points[0][1] > 6.55*10**6:
            coord.append(shape.points[0])
    except IndexError:
        pass
    
X = np.array(coord) 
db = DBSCAN(eps=0.3, min_samples=15).fit(X)
core_samples_mask = np.zeros_like(db.labels_, dtype=bool)
core_samples_mask[db.core_sample_indices_] = True
labels = db.labels_

# Number of clusters in labels, ignoring noise if present.
n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)

# Black removed and is used for noise instead.
unique_labels = set(labels)
colors = plt.cm.Spectral(np.linspace(0, 1, len(unique_labels)))

plt.figure(figsize=(50, 50))
# Setup cartographic data for plot
ax = plt.axes(projection=proj)

# Specify a region of interest, in this case, Calgary.
ax.set_extent([-114.3697, -113.8523, 50.8567, 51.2447],
          ccrs.PlateCarree())

# Add the tiles at zoom level 11.
ax.add_image(osm_tiles, 11)

for k, col in zip(unique_labels, colors):
    if k == -1:
        # Black used for noise.
        col = 'k'

    class_member_mask = (labels == k)
    
    xy = X[class_member_mask & core_samples_mask]
    plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=col,
             markeredgecolor='k', markersize=15)

    xy = X[class_member_mask & ~core_samples_mask]
    plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=col,
             markeredgecolor='k', markersize=0.2)

plt.title('Estimated number of clusters: %d' % n_clusters_)
plt.savefig('../Outputs/Cluster.png', transparent=True)