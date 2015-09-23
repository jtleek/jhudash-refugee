This is code used to collect data for the refugee project at #jhudash 2015
------------------------------

Data spreadsheet is here: 

https://docs.google.com/spreadsheets/d/1eRDlcwkT0hqqi-DNVU4dgJHxKRsLYY0VAqOMjxcD2r8/edit?usp=sharing

----
Compatibility Model

This model operates on the basic principle that refugees will more successfully resettle in an area that is similar to their home country (before it was in crisis).  We considered 21 different variables to measure this similarity.  These variables fit broadly into three different categories:

1) Economic:
    - percent of GDP from industry/services/agriculture
    - education level of workforce
    - household expenditures, government expenditures, etc.

2) Social:
    - percentage of population that is Muslim
    - hospitals and physicians per 1000
    - percent of GDP spent on education and health care
    
3) Geographic Distance:
    - as the crow flies, from Damascus

We standardized all of these measures to be between 0 and 1, to minimize the effect of certain measures which vary wildly.  For instance Cyprus is 328 miles away, whereas New Zealand is 16,000.  Without standardization, this quickly becomes the deciding factor.


----
Capacity Model

This model is a multiple linear regression on a sub-set of the data we scraped to predict the 2009 global refugee population by country.  We used this as a first-order metric for capacity and iteratively performed linear regression and removed variables that did not contribute to the overall fit (based on P-value).  We found that the best model incorporates GDP by use (as a percentage towards industry, services, and agriculture), the percent of the country primary educated, and the percent of GDP used for healthcare.

We then standardized the predicted values for all countries and normalized them on a scale of 0-100.  We found that the results seem realistic.  Germany and the United States have the highest capacity while small Middle-Eastern and Northern African countries have the lowest capacity.


    
