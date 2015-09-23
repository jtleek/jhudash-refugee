##setwd("C:/Users/Seth/Documents/JHU DaSH/")
##write.csv(newDat, "newDat.csv", row.names=F)

library(rvest)
library(googlesheets)
library(dplyr)

### LOAD IN GOOGLE SHEET
#library(googlesheets)
my_url = "https://docs.google.com/spreadsheets/d/1eRDlcwkT0hqqi-DNVU4dgJHxKRsLYY0VAqOMjxcD2r8/pubhtml"
my_gs = gs_url(my_url)
dat = gs_read(my_gs)
#newDat <- dat

## GDP BY USE
url <- "https://www.cia.gov/library/publications/the-world-factbook/fields/2012.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="fieldListing"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(unlist(strsplit(data[i,2], ": ")), "%"))
    data$agriculture[i] <- split[2]
    data$industry[i] <- split[4]
    data$services[i] <- split[6]
}

gdpByUse <- data[,c(1,3:5)]
names(gdpByUse)[2:4] <- paste("gdpByUse", ".", names(gdpByUse)[2:4], by="")

#add to google doc
newDat <- left_join(dat, gdpByUse, by=c("Country.Name"="Country"))


## GDP BY END
url <- "https://www.cia.gov/library/publications/the-world-factbook/fields/2259.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="fieldListing"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(unlist(strsplit(data[i,2], ": ")), "%"))
    data$household[i] <- split[2]
    data$government[i] <- split[4]
    data$invFixedCapital[i] <- split[6]
    data$invInventories[i] <- split[8]
    data$exports[i] <- split[10]
    data$imports[i] <- split[12]
}

gdpByEnd <- data[,c(1,3:7)]
names(gdpByEnd)[2:6] <- paste("gdpByEnd", ".", names(gdpByEnd)[2:6], by="")

#add to google doc
library(dplyr)
newDat <- left_join(newDat, gdpByEnd, by=c("Country.Name"="Country"))

## AGE
url <- "https://www.cia.gov/library/publications/the-world-factbook/fields/2010.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="fieldListing"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(unlist(strsplit(unlist(strsplit(data[i,2], ": ")), "%")), ")"))
    data$age0_14[i] <- split[2]
    data$age15_24[i] <- split[5]
    data$age25_54[i] <- split[8]
    data$age55_64[i] <- split[11]
    data$age64_over[i] <- split[14]
}

age <- data[,c(1,3:7)]

#add to google doc
newDat <- left_join(newDat, age, by=c("Country.Name"="Country"))

## POP GROWTH
url <- "https://www.cia.gov/library/publications/the-world-factbook/fields/2002.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="fieldListing"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(unlist(strsplit(data[i,2], ": ")), "%"))
    data$popGrowth[i] <- split[1]
}

popGrowth <- data[,c(1,3)]

#add to google doc
newDat <- left_join(newDat, popGrowth, by=c("Country.Name"="Country"))

## DEPENDENCY RATE
url <- "https://www.cia.gov/library/publications/the-world-factbook/fields/2261.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="fieldListing"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(unlist(strsplit(data[i,2], ": ")), "%"))
    data$dependencyRatio[i] <- split[2]
}

dependencyRatio <- data[,c(1,3)]

#add to google doc
newDat <- left_join(newDat, dependencyRatio, by=c("Country.Name"="Country"))

## HEALTH EXPENDITURES
url <- "https://www.cia.gov/library/publications/the-world-factbook/fields/2225.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="fieldListing"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(unlist(strsplit(data[i,2], ": ")), "%"))
    data$healthExpPercOfGDP[i] <- split[1]
}

healthExpPercOfGDP <- data[,c(1,3)]

#add to google doc
newDat <- left_join(newDat, healthExpPercOfGDP, by=c("Country.Name"="Country"))

## EDUCATION EXPENDITURES
url <- "https://www.cia.gov/library/publications/the-world-factbook/fields/2206.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="fieldListing"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(unlist(strsplit(data[i,2], ": ")), "%"))
    data$educationExpPercOfGDP[i] <- split[1]
}

educationExpPercOfGDP <- data[,c(1,3)]

#add to google doc
newDat <- left_join(newDat, educationExpPercOfGDP, by=c("Country.Name"="Country"))

## PHYSICIANS PER THOUSAND
url <- "https://www.cia.gov/library/publications/the-world-factbook/fields/2226.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="fieldListing"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(data[i,2], " "))
    data$physiciansPer1000[i] <- split[1]
}

physiciansPer1000 <- data[,c(1,3)]

#add to google doc
newDat <- left_join(newDat, physiciansPer1000, by=c("Country.Name"="Country"))

## HOSPITALS PER THOUSAND
url <- "https://www.cia.gov/library/publications/the-world-factbook/fields/2227.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="fieldListing"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(data[i,2], " "))
    data$hospitalsPer1000[i] <- split[1]
}

hospitalsPer1000 <- data[,c(1,3)]

#add to google doc
newDat <- left_join(newDat, hospitalsPer1000, by=c("Country.Name"="Country"))


## TOTAL POP
url <- "https://www.cia.gov/library/publications/resources/the-world-factbook/rankorder/2119rank.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="rankOrder"]') %>% html_table()

data <- data.frame(data)

for (i in 1:nrow(data)) {
    split <- unlist(strsplit(data[i,2], " "))
    data$totalPop[i] <- split[1]
}

totalPop <- data[,c(2,3)]

#add to google doc
newDat <- left_join(newDat, totalPop, by=c("Country.Name"="Country"))

## LABOR FORCE
url <- "https://www.cia.gov/library/publications/the-world-factbook/rankorder/2095rank.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="rankOrder"]') %>% html_table()

data <- data.frame(data)

laborForce <- data[,c(2,3)]

#add to google doc
newDat <- left_join(newDat, laborForce, by=c("Country.Name"="Country"))

## area
url <- "https://www.cia.gov/library/publications/the-world-factbook/rankorder/2147rank.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="rankOrder"]') %>% html_table()

data <- data.frame(data)

area <- data[,c(2,3)]

#add to google doc
newDat <- left_join(newDat, area, by=c("Country.Name"="Country"))

## MIGRATION RATE
url <- "https://www.cia.gov/library/publications/the-world-factbook/rankorder/2112rank.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="rankOrder"]') %>% html_table()

data <- data.frame(data)

migrationRate <- data[,c(2,3)]
names(migrationRate)[2] <- "migrationRate"

#add to google doc
newDat <- left_join(newDat, migrationRate, by=c("Country.Name"="Country"))

## YOUTH UNEMPLOYMENT
url <- "https://www.cia.gov/library/publications/the-world-factbook/rankorder/2229rank.html"

data <- url %>% html %>% html_nodes(xpath='//*[@id="rankOrder"]') %>% html_table()

data <- data.frame(data)

youthUnemployment <- data[,c(2,3)]
names(youthUnemployment)[2] <- "youthUnemployment"

#add to google doc
newDat <- left_join(newDat, youthUnemployment, by=c("Country.Name"="Country"))

#### ADDING TEACHER SALARY
teachers <- read.csv("teachers salary.csv", stringsAsFactors=F, header=F)
for (i in 1:nrow(teachers)) {
    teachers[i,2:ncol(teachers)] <- gsub(" ", "", teachers[i,2:ncol(teachers)])
    
}
teachers <- teachers[,c(1,5)]
teachers <- teachers[-4,]
teachers[3,1] <- "Belgium"
names(teachers)[2] <- "teacherSalary"

newDat <- left_join(newDat, teachers, by=c("Country.Name"="V1"))
