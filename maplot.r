#!/usr/bin/Rscript

# README:
# This is an Rscript to plot a single shapefile from Linux terminal for data checking -
# i.e. sometimes I have an urge to see shapefile visually (and witih coordinates!) without opening QGIS -
# e.g. ./scripts/maplot.r "~/GEE/python/publdsur.shp"
# (or loudly..) Rscript ~/scripts/maplot.r "publdsur.shp"

# required (needs to be installed prior in R) for maptools = sp, rgeos
# normally, this commandArgs() - without (TRUE) - come with the following arguments
# print(commandArgs)
# [1] "/usr/lib/R/bin/exec/R"               
# [2] "--slave"                             
# [3] "--no-restore"                        
# [4] "--file=/home/chieko/scripts/maplot.r"
# [5] "--args"                              
# [6] "publdsur.shp" 

library(rgdal)

input <-commandArgs(TRUE)

# readOGR is a bit goofy - I need to give a data source (directory)
dsn   <-dirname(input[1])
if(is.null(dsn)){
  dsn <-"."
}

# AND also file name without extension
layer=sub("^([^.]*).*", "\\1", basename(input[1]))

# print the layer information
ogrInfo(dsn=dsn, layer=layer)

# plot the layer on a new window..
shp <- readOGR(dsn=dsn, layer=layer, verbose=F)

X11()

plot(shp, border = "blue", pch = 10, axes = T)

# pause to give time to examine the plot
message("Press return to close the plot window..")
invisible(readLines("stdin", n=1))
