# find_median
# output: median value (numeric, could be decimal NOT always integer)
# usage : hhincmedian<-find_median(sums,hhincupp,"hhinc")
# input1: df (data.frame)
# input2: upps (numeric vector, upper values of each class/range)
# eg: hhincupp<-c(9999,14999,19999,24999,29999,34999,39999,44999,49999,59999,74999,99999,124999,149999,199999,200000)
# input3: vheader (string/char, standard variable header name, i.e. "hhinc" for hhinc1, hhinc2, hhinc3, etc.)
# eg: hhinc1 hhinc2 hhinc3 hhinc4 hhinc5 hhinc6 hhinc7 hhinc8 hhinc9 hhinc10 hhinc11 hhinc12 hhinc13 hhinc14 hhinc15 hhinc16
#       3051   1675   1394   1604   1327   1284   1002   1026    830    1494    2256    2477    1383     963     953     765
# assumption: value classes/ranges has "descriptive header" (eg: hhinc) and ordered numeric value (eg:1-) which always starts at 1
find_median <-function(df,upps,vheader){
  vtotal<-0
  for(i in 1:length(upps)){          # vtotal:   get the total number of cases, i.e. universe
    vname<-paste0(vheader,i)         # vname: hhinc1, hhinc2, hhinc3, etc.
    vtotal<-vtotal+df[[vname]]
  }
  midpoint<-vtotal/2                 # midpoint: get the middle point (i.e. middle case#) value
  jclass<-0                          # jclass:   current index of the class/range, to be used to point at upps index values (vlower, vupper)
  k<-0                               # k:        accumulated number of cases
  n<-1                               # n:        current loop location - can be made redundant, as is always equal to jclass+1
  while(k<midpoint){                 # do while k reaches to the midpoint to find in which var/class/range the midpoint falls in=
    vname<-paste0(vheader,n)         # vname:    the last vname would be the name of var/class/range containing the median/midpoint
    k=k+df[[vname]]                  # keep adding N of cases in the current var/class/range
    jclass=jclass+1
    n<-n+1
  }
  vlower<-0                          # set lower range value to zero in case median falls in the first var/class/range
  if (n>2){                          # set lower range value to a value from one index prior to the current upper range value
    vlower<-upps[jclass-1]
  }
  vupper<-upps[jclass]               # set upper range value to a value from the current upper range value
  vbegin<-k-df[[vname]]              # set the beginning case #
  #print(paste("vbegin is:",vbegin))
  vincre<-(vupper-vlower)/df[[vname]]# set increment value in the var/class/range
  vmedian<-vlower                    # set starting median value with the lower possible value in the var/class/range
  while(vbegin<midpoint){            # do/increase vmedian value with the increment value until case# reaches to midpoint#
    vmedian<-vmedian+vincre
    vbegin<-vbegin+1
  }
  # print(paste("midpoint is:",midpoint)) #eg: [1] "midpoint is: 11742"
  # print(paste("vname is:",vname))       #eg: [1] "vname is: hhinc8"
  # print(paste("vlower is:",vlower))     #eg: [1] "vlower is: 39999"
  # print(paste("vupper is:",vupper))     #eg: [1] "vupper is: 44999"
  # print(paste("vmedian is:",vmedian))   #eg: [1] "vmedian is: 41972.6842105271"
  return(vmedian)
}
