## Eugene Cho
## JHU DaSH 9/21/2015-9/23/2015 
## Library Loading
library(rvest)
library(googlesheets)
library(dplyr)
library(readr)
library(ggplot2)
library(scales)
library(cvTools)
#library(lpSolve)
## GoogleSheet Loading
my_url = "https://docs.google.com/spreadsheets/d/1eRDlcwkT0hqqi-DNVU4dgJHxKRsLYY0VAqOMjxcD2r8/pubhtml"
my_gs = gs_url(my_url)
dat = gs_read(my_gs)
name<-dat$Country.Name
cost<-rep(0,length(dat$Cost.per.Refugee))
for (i in 1:length(dat$Cost.per.Refugee)) {
  dat$Cost.per.Refugee[i]<-gsub(",([0-9])", "\\1", dat$Cost.per.Refugee[i])
  cost[i]<-as.numeric(dat$Cost.per.Refugee[i])
}
gdp<-rep(0,length(dat$Cost.per.Refugee))
for (i in 1:length(dat$GDP_per_Capita_2014)) {
  dat$GDP_per_Capita_2014[i]<-gsub(",([0-9])", "\\1", dat$GDP_per_Capita_2014[i])
  gdp[i]<-as.numeric(dat$GDP_per_Capita_2014[i])
}
refpop<-as.numeric(dat$RefugeePopulation2009)
teacher<-as.numeric(dat$teacherSalary)
gdp_growth<-as.numeric(dat$GDP_Growth_2014)
hosp<-as.numeric(dat$hospitalsPer1000)
cpi<-as.numeric(dat$Consumer.Price.Index.plus.rent.index)
health<-dat$healthExpPercOfGDP
edu<-dat$educationExpPercOfGDP
model_dat<-data.frame(name, cost, gdp_growth, gdp, cpi, health, edu, hosp, refpop,teacher)
train_dat<-model_dat[complete.cases(model_dat[, "cost"]), ]
test_dat<-model_dat[!complete.cases(model_dat[,"cost"]), ]
glm_model<-glm(cost~I(cpi^2)+I(edu^2)+cpi+edu,data=train_dat,family="poisson")
summary(glm_model)
qplot(glm_model$fitted, train_dat$cost, label=train_dat$name, geom="text")
lm_model<-lm(cost~ cpi*edu,data=train_dat)
cvFit(lm_model, data=train_dat, y=train_dat$cost, foldType="consecutive")
summary(lm_model)
qplot(lm_model$fitted, train_dat$cost, label=train_dat$name, geom="text")
test_dat$cost<-predict(lm_model, test_dat)
table(sign(test_dat$cost))
View(test_dat)
complete_dat<-rbind(test_dat,train_dat)
