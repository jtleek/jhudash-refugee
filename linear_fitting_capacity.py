"""
Let's fix the Syrian Refugee problem! #JHUDash2015
-------------------------------------------------------------------------------
Script name:     linear_fitting_capacity.py
First written:   2015.09.22
Last edited:     2015.09.23

Purpose:
The script was written by Hesam Motlagh and John Belcher at the 2015 JHU-Dash
hackathon for the purposes of estimating the capacity of each country to take
on Syrian refugees.  The program reads in the masked data, performs multiple
linear regression to predict # refugees in 2009 (as a proxy for capacity), and
iteratively removes variables by p-values until there are none left.  The data
are written into a file where the user can inspect by hand and pick the best
model.
"""
import sys, math, os, string, csv #import other stuff we need
import numpy as np
from scipy import stats
import pandas as pd
import math
import statsmodels.api as sm

#read in the masked data set that was cleaned up to remoe NaN values
data = pd.read_csv("capacity_model_full_masked.csv")
#take in the column header names, these are the variables we will fit with
variables = []
for x in data:
    variables.append(x)
#Remove the value we're fitting for (refugee population) and Country Names
variables.remove('RefugeePopulation2009')
variables.remove('Country.Name')
#we'll store our data in the following variables
out_data,count = [], 0
#want R-squared, variables, Prob (F-statistic) - they will be recorded in the 
#following two output files, one for all the output (output_all.dat) and the
#fitting statistics of interest (output.dat)
outfile,outdat = open("output.dat",'w'),open("output_all.dat",'w')
#what data are we fitting to?  This is our dependent variable
y = data['RefugeePopulation2009']
#iterate over the list of variables systematically removing independent 
#variables until there is only one left
while len(variables) > 1:
    x = data[variables]
    x2 = sm.add_constant(x) #add a constant for fitting purposes
    est = sm.OLS(y,x2).fit() #do an ordinary least squares fit
    output = est.summary() #save the summary of the fit
    #what do we want for each fit? (1) #variables, (2) R-squared, (3) Adj-R-sqrd
    #(4) Prob(F-statistic) max p-value for all the variables --> and var name
    #p-values = 37, 42, 47, this index is 1:1 with variables
    output_csv = output.as_csv() #convert output to CSV
    pvals = [] #this will be a list of the p-values for each variable
    for idx in range(len(variables)+1):
        pvals.append(float(output_csv.split(",")[37+5*idx]))
    #at this point we will save the F-statistics and R-squared
    f_p = float(output_csv.split(",")[13][0:7])
    r_s = float(output_csv.split(",")[3][0:9])
    count += 1
    #output the simple statistics to outfile
    outfile.write(str(count)+","+str(len(variables))+","+str(r_s)+","+str(f_p)+\
                  ","+str(max(pvals))+"\n")
    #ok, so which index of the variables do we want to remove? the max p-value
    idx_to_rem = pvals.index(max(pvals))-1
    print "removing variable " + str(variables[idx_to_rem])
    del variables[idx_to_rem] #now remove the variable to resume fitting
    to_write = str(output.as_text) 
    outdat.write(to_write)#output the entire summary as a text file
    outdat.write("-----------------------------------------------------\n\n\n")
    
outfile.close()
outdat.close()
#close the last two files, and we should be good 


    
