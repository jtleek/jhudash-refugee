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
Cost Model

This model considers the economic cost of hosting a refugee from the government's perspective. We used the training data from the OECD research in an attempt to replicate their analysis of the expenditure, which included temporary sustenance of food, clothing, and shelter, as well as long term professional training. We considered a combination of 8 different possible variables that can contribute to the expenditure calculation. 

As a disclaimer, the training set is skewed since it only contains the cost of OECD countries and may not be suitable to model emerging markets.

Using multinomial linear regression and cross validation to avoid overfitting, we reached an equation:

Cost = B0 + B1 x CPI + B2 x Edu + B3 x CPI x Edu

where

    Cost = Cost to the government per refugee (in 2015 USD) 
    CPI = consumer price index plus rent index
    Edu = Education expenditure as a percentage of GDP

Using the predicted cost data, found the number of refugees each country needs to harbor, such that the cost of refugees is the same percentage of its GDP.
The model allows us to rank the countries by the economic availability to host the refugees.


----
Capacity Model

This model is a multiple linear regression on a sub-set of the data we scraped to predict the 2009 global refugee population by country.  We used this as a first-order metric for capacity and iteratively performed linear regression and removed variables that did not contribute to the overall fit (based on P-value).  We found that the best model incorporates GDP by use (as a percentage towards industry, services, and agriculture), the percent of the country primary educated, and the percent of GDP used for healthcare.

We then standardized the predicted values for all countries and normalized them on a scale of 0-100.  We found that the results seem realistic.  Germany and the United States have the highest capacity while small Middle-Eastern and Northern African countries have the lowest capacity.


    
