# -*- coding: utf-8 -*-
"""
Created on Fri Jan 20 15:33:07 2017

@author: jason
"""

import pandas as pd

DIST_CONV = 1.417 # https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3835347/

zn_dist = pd.read_csv('../CSV/taz_dist_mat_in.csv')
tr_SOV = pd.read_csv('../CSV/trip_mat_SOV.csv')
tr_SOV = tr_SOV.set_index(['ZONE'])
tr_SOV.columns = tr_SOV.columns.astype(int)
tr_HOV = pd.read_csv('../CSV/trip_mat_HOV.csv')
tr_HOV = tr_HOV.set_index(['ZONE'])
tr_HOV.columns = tr_HOV.columns.astype(int)
tr_active = pd.read_csv('../CSV/trip_mat_active.csv')
tr_active = tr_active.set_index(['ZONE'])
tr_active.columns = tr_active.columns.astype(int)
tr_transit = pd.read_csv('../CSV/trip_mat_transit.csv')
tr_transit = tr_transit.set_index(['ZONE'])
tr_transit.columns = tr_transit.columns.astype(int)

piv_dist = zn_dist.pivot(index='InputID',columns='TargetID',values='Distance')
piv_dist = piv_dist.fillna(2000)
piv_dist = piv_dist/1000

SOV_dist = piv_dist.multiply(tr_SOV)
SOV_dist = SOV_dist.values.sum()*DIST_CONV

HOV_dist = piv_dist.multiply(tr_HOV)
HOV_dist = HOV_dist.values.sum()*DIST_CONV

active_dist = piv_dist.multiply(tr_active)
active_dist = active_dist.values.sum()*DIST_CONV

transit_dist = piv_dist.multiply(tr_transit)
transit_dist = transit_dist.values.sum()*DIST_CONV

auto_dist = SOV_dist+HOV_dist
tot_dist = SOV_dist+HOV_dist+active_dist+transit_dist

print("SOV:",SOV_dist)
print("HOV:",HOV_dist)
print("AUTO:",auto_dist)
print("ACTIVE:",active_dist)
print("TRANSIT:",transit_dist)
print("TOTAL:",tot_dist)
