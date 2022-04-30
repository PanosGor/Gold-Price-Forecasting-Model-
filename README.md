# Gold-Price-Forecasting-Model-
Gold prediction model in R

## Data Preprocessing

- Identify missing values-Days and Prices missing from original database file
- Create an average price per week table to fill the missing values
- Plot the data after the preprocessing
- Very interesting the spike happening around 2011, which resulted to higher prices up until 2018
- Also plotted the average price per day to analyze the patterns and differences between days
- As it is shown there are no significant differences between days, which results to no pattern identified
- Last step was to prepare an average price per month and year table for the forecasting part

![image](https://user-images.githubusercontent.com/82097084/166111172-806adcda-8473-4f48-b0a2-952b89e00686.png)

![image](https://user-images.githubusercontent.com/82097084/166111210-8653f125-81b5-4019-9158-64c24ee53a10.png)

## Forecasting

- Using the preprocessed dataset, we used Auto ARIMA, to forecast the next 12 months after the data ends
- Data used for forecasting are after 2014, due to the fact that after 2014, the data were developing with a more steady rhythm
- In the plot the red line shows the prediction on top of the actual data
- In the table are the forecasted average prices per month, along with the Low and High Confidence for levels 95 and 99

![image](https://user-images.githubusercontent.com/82097084/166111237-7740028b-393c-4271-9189-f9c5a6fa78ca.png)

![image](https://user-images.githubusercontent.com/82097084/166111275-a3009e32-2b91-4b89-80ca-f89de6960181.png)

## Forecasting evaluation

- After applying the forecasting of ARIMA we exported the accuracy results
- The MAPE of 3,55 gives a very good forecast error result
- Based on our calculations we compared the realized price of Gold after 6 months with our forecasted price
- Based on the ROI calculated of 5,08% and the MAPE of 3,55%, an investment would be justified

![image](https://user-images.githubusercontent.com/82097084/166111397-f460c60d-e594-470b-b8c2-039b1429489f.png)

![image](https://user-images.githubusercontent.com/82097084/166111444-d32ae552-2dfb-4311-980b-c56662ec0a43.png)

## Conclusion 

- From September 2010 to September 2011, gold prices jumped 50.6 percent, mainly the result of speculation surrounding an uneven recovery and volatility in the U.S. financial markets, with gold reaching an all-time high of $1,917.90 per ounce in August 2011.
- It is possible in the future a likewise event might cause a similar spike, which will through all forecasting models off, because factors like market crush cannot be predicted



