setwd("C:/Users/Seth/Documents/JHU DaSH/")
##write.csv(newDat, "newDat.csv", row.names=F)

library(rvest)
library(googlesheets)
library(dplyr)


### LOAD IN GOOGLE SHEET
#library(googlesheets)
my_url = "https://docs.google.com/spreadsheets/d/1eRDlcwkT0hqqi-DNVU4dgJHxKRsLYY0VAqOMjxcD2r8/pubhtml"
my_gs = gs_url(my_url)
dat = gs_read(my_gs)
gDat <- rbind(dat, syrDat)
#syrDat <- read.csv("syrDat.csv", stringsAsFactors=F)
syrDat <- gs_read(my_gs, ws="syrDat")

gDat <- gDat[, c(1,7:9,11:15,18, 19:23, 25:30,79)]

library(impute)
igDat = impute.knn(as.matrix(as.data.frame(gDat)[,-1]),k=3)
gDat = cbind(gDat[,1],igDat$data)

#standardized
sDat <- gDat
for (j in 2:ncol(sDat)) {
    sDat[,j] <- (sDat[,j]-min(sDat[,j]))/max(sDat[,j])
    #if(sDat[i,j]<=0) {sDat[i,j] <- 0.01}
}
distS <- as.matrix(dist(sDat[,-1]))
matchS <- data.frame(Compatibility=seq(100,2 , by=-2), 
                     Country=sDat$Country.Name[order(distS[50,])],
                     stringsAsFactors=F)

compatibilityRank <- left_join(dat, matchS, by=c("Country.Name"="Country"))
compatibilityRank <- compatibilityRank[, c(1, ncol(compatibilityRank))]

##setwd("C:/Users/Seth/Documents/JHU DaSH/")
#write.csv(compatibilityRank, "compatibilityRank.csv", row.names=F)
