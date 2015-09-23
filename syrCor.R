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

###START HERE, after first time

#considering distance
distMD <- as.matrix(dist(gDat[,-1]))
matchRaw <- data.frame(rankRaw=seq(1,50), Country=gDat$Country.Name[order(distMD[50,])])

#not considering distance
distM <- as.matrix(dist(gDat[,-c(1,24)]))
matchND <- data.frame(rankND=seq(1,50), Country=gDat$Country.Name[order(distM[50,])])

#log2
l2Dat <- gDat
for (i in 1:nrow(l2Dat)) {
    for (j in 2:ncol(l2Dat)) {
        if(l2Dat[i,j]<=0) {l2Dat[i,j] <- 0.01}
        l2Dat[i,j] <- log2(l2Dat[i,j])
    }
}
distL2 <- as.matrix(dist(l2Dat[,-1]))
matchL2 <- data.frame(rankL2=seq(1,50), Country=l2Dat$Country.Name[order(distL2[50,])])

#log2ND
distL2ND <- as.matrix(dist(l2Dat[,-c(1,24)]))
matchL2ND <- data.frame(rankL2ND=seq(1,50), Country=l2Dat$Country.Name[order(distL2ND[50,])])

#standardized
sDat <- gDat
for (j in 2:ncol(sDat)) {
        sDat[,j] <- (sDat[,j]-min(sDat[,j]))/max(sDat[,j])
        #if(sDat[i,j]<=0) {sDat[i,j] <- 0.01}
}
distS <- as.matrix(dist(sDat[,-1]))
matchS <- data.frame(rankS=seq(1,50), Country=sDat$Country.Name[order(distS[50,])])

#standardized ND
distSND <- as.matrix(dist(sDat[,-c(1,24)]))
matchSND <- data.frame(rankSND=seq(1,50), Country=sDat$Country.Name[order(distSND[50,])])


#comparing them
matches <- data.frame(Country=as.character(matchRaw[order(matchRaw$Country),2]),
                 rankRaw=matchRaw[order(matchRaw$Country),1], 
                 rankND=matchND[order(matchND$Country),1],
                 rankL2=matchL2[order(matchL2$Country),1],
                 rankL2ND=matchL2ND[order(matchL2ND$Country),1],
                 rankS=matchS[order(matchS$Country),1],
                 rankSND=matchSND[order(matchSND$Country),1])
avgRank <- numeric(nrow(matches))
for (i in 1:nrow(matches)){
    avgRank[i] <- round(mean(as.numeric(matches[i,2:ncol(matches)])), 2)
}
matches <- cbind(avgRank, matches)
matches <- matches[order(matches$avgRank),]
