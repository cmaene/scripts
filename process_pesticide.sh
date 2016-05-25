cd ~/Documents/Lymphoma/pesticide
#mkdir rasters

# can't bulk download (wget -A zip) - 403 error - at once
# download a webpage which includes a list of files
curl -O http://water.usgs.gov/GIS/dsdl/agpest97grd/index97.html

# clean the list of selected files to be downloaded
cat index97.html \
| sed -n '/<li>/,/<\/li>/p' \
| sed -n '/): <a href=\"/,/\">ASCII<\/a> \|/p' \
| sed -e '/^<\/ul>/d' -e 's/^.*: <a href=\"//' -e 's/\">ASCII.*//' \
> downloadlist.txt

cd rasters
# finally, download the list one by one
while IFS=, read -a line
do
    curl -O http://water.usgs.gov/GIS/dsdl/agpest97grd/${line[0]}
done < ../downloadlist.txt

# unzip all the zip file in the directory
unzip \*.zip

cd ../

# make another list to be merged
cat downloadlist.txt | sed -e 's/_97.zip//g' > AAIGridlist.txt

# delete the first grid name (kg8008) and also bad zipfiles
sed -i '1d' AAIGridlist.txt
cat AAIGridlist.txt | sed -e 's/\(kg6025\|kg6051\|kg6083\|kg7008\|kg8009\)//g' > AAIGridlist.txt
sed -i '/^$/d' AAIGridlist.txt

# keep the first grid as the main summing-up grid
cp rasters/kg8008_97/kg8008.asc sum.asc 
cp rasters/kg8008_97/kg8008.prj sum.prj

# sum up all the grid
while IFS=, read -a line
do
    #gdalinfo -stats -approx_stats sum.asc
    # gdal_translate -a_nodata -999 -of GTiff ${line[0]}.asc raster.tif #no need for conversion
    echo ${line[0]}  # some ZIP files were corrupted
    gdal_calc.py -A sum.asc -B rasters/${line[0]}_97/${line[0]}.asc --outfile=temp.asc --calc="A+B" #--NoDataValue=0 #--format=AAIGrid doesn't work
    rm sum.asc
    cp temp.asc sum.asc
    rm temp.asc
done < AAIGridlist.txt 
# rename to TIF as the gdal_calc.py produces TIF (format option doesn't work)
cp sum.asc sum.tif

#cp sum.asc sum_copy.asc
#cat sum.asc | sed -e 's/-9999/0/g' > sum_zeronodata.asc

# download failed ArcINFO grid versions for the failed ones (kg6025 kg6051 kg6083 kg7008 kg8009)
cd rasters
badfiles=(kg6025 kg6051 kg6083 kg7008 kg8009)
for file in "${badfiles[@]}"
do
    curl -O http://water.usgs.gov/GIS/dsdl/agpest97grd/${file}_97.tar.gz
done
tar -xvzf \*.tar.gz
cd ../

# following 5 were corrupted - use ArcINFO version instead # this turned out to be a big pain!
gdal_translate -of AAIGrid --overwrite rasters/arctar00000/kg6025 rasters/kg6025/kg6025_2.asc
# first bad file
cp rasters/kg6025_97/kg6025_2.asc sum2.asc 
cp rasters/kg6025_97/kg6025_2.prj sum2.prj
# the rest
badfiles=(kg6051 kg6083 kg7008 kg8009)
for file in "${badfiles[@]}"
do
    echo ${line[0]}
    gdal_translate -of AAIGrid rasters/arctar00000/${file} rasters/${file}_97/${file}_2.asc
    gdal_calc.py -A sum2.asc -B rasters/${file}_97/${file}_2.asc --outfile=temp2.asc --calc="A+B" --overwrite  #--NoDataValue=0 #--format=AAIGrid doesn't work
    rm sum2.asc
    cp temp2.asc sum2.asc
done

# rename to TIF as the gdal_calc.py produces TIF (format option doesn't work)
cp sum2.asc sum2.tif

# combined the two results
# it appears that output will be NULL if A is NULL, even if B is not
# the opposite doesn't happen
gdal_calc.py -A sum.tif -B sum2.tif --outfile=sum_combined.tif --calc="A+B" --overwrite #--NoDataValue=0 #--format=AAIGrid doesn't work
# gdal_calc.py -A sum.asc -B sum2.asc --outfile=sum_combined.asc --calc="A+B" --overwrite

# now reproject county shapefile also for QGIS zonal_statistics tool
# first get the SRS from the sum_combined.tif
gdalsrsinfo -o wkt sum_combined.tif > sum_combined_srs.txt
ogr2ogr -overwrite -t_srs sum_combined_srs.txt tl_2010_us_county10_albersconicea.shp tl_2010_us_county10.shp

# finish in QGIS to run zonal_statistics tool.
