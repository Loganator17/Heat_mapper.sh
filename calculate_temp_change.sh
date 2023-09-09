#!/usr/bin/env bash

# We're using the solution in Eq. 5 from Wittmann et al. (2016) 
# doi: 10.1002/2016JB013444
#
# dT = dh / (gamma * alpha * h)
#
# h: thickness of lava flow (m)
# dT: temperature change (K)
# gamma: 1.7 (contraction coefficient for Poisson ratio - 0.25 (-)
# alpha: thermal expansivity (1/K), 
# 	 use values between 8.3e-6 to 3e-6 (Hekla lava to Hawaii basalt), 
#    	 the latter may be more appropriate.

#For the flow thickness, we have a grdfile:
#	/gps/GMT/Iceland/DEM/holuhraun_lava_flow_1m.grd
#
# find a plot of it here:
#	/gps/GMT/Iceland/holuhraun_flow.pdf
#

lava_thickness=/InSAR/Bardarbunga/lava_cooling/h.grd
surface_change=/InSAR/Bardarbunga/time_series_analysis/path09/SBAS/vel_ll_test.grd
gamma="1.7"
alpha="8.3e-6"
region=-R-16.8646896071/-16.5136666667/64.8495555556/64.9370237575
#`grdinfo -I0.0000000001/0.00000000001 $lava_thickness`	#has the smaller region
increment=-I0.00111123938517/0.000417493907477
#`grdinfo -I $lava_thickness`			#has the coarser resolution

echo "Lava Thickness: " $lava_thickness
echo "Surface Change: " $surface_change
echo "Comp Region: "  	$region
echo "node spaceing:" 	$increment

echo "Resampling, resizing the grids"
gmt grdsample -T $region $increment $lava_thickness -Gh_new.grd
gmt grdsample -T $region $increment $surface_change -Gdh.grd

# calculate denominator first                
gmt grdmath $gamma $alpha MUL h_new.grd MUL = denom.grd
# convert surface change to meters, divide by denominator
gmt grdmath dh.grd 1000 DIV denom.grd DIV  = dT.grd



#EOF

