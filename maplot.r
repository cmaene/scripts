#!/usr/bin/Rscript

# e.g. Rscript ~/scripts/maplot.r publdsur.shp
# e.g. Rscript ~/scripts/maplot.r "~/Documents/GEE/python/publdsur.shp"

# required (needs to be installed prior in R) for maptools = sp, rgeos
library(maptools)
input <-commandArgs(TRUE)
# normally, this commandArgs() - without (TRUE) - come with the following arguments
# [1] "/usr/lib/R/bin/exec/R"               
# [2] "--slave"                             
# [3] "--no-restore"                        
# [4] "--file=/home/chieko/scripts/maplot.r"
# [5] "--args"                              
# [6] "publdsur.shp" 

print(input)

shp <- readShapeSpatial(input[1])
# print(class(shp))

X11()
plot(shp, border = "blue", pch = 10, axes = T)

# pause to give time to examine the plot
message("Press return to close the plot")
invisible(readLines("stdin", n=1))
