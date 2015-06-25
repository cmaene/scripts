#!/usr/bin/Rscript

# README:
# This is an Rscript to plot a single shapefile from Linux terminal for data checking -
# i.e. sometimes I have an urge to see shapefile visually (and witih coordinates!) without opening QGIS -
# e.g. Rscript maplot.r "~/GEE/python/publdsur.shp"

# required (needs to be installed prior in R) for maptools = sp, rgeos
# normally, this commandArgs() - without (TRUE) - come with the following arguments
# print(commandArgs)
# [1] "/usr/lib/R/bin/exec/R"               
# [2] "--slave"                             
# [3] "--no-restore"                        
# [4] "--file=/home/chieko/scripts/maplot.r"
# [5] "--args"                              
# [6] "publdsur.shp" 

library(maptools)

input <-commandArgs(TRUE)

shp <- readShapeSpatial(input[1])

X11()

plot(shp, border = "blue", pch = 10, axes = T)

# pause to give time to examine the plot
message("Press return to close the plot window..")
invisible(readLines("stdin", n=1))
