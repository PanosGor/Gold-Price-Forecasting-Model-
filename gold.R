#DO NOT FORGET TO SET THE RIGHT WORKING DIRECTORY FIRST

library(forecast)
library(smooth)
library(dplyr)
library(tidyr)
library(hablar)
library(data.table)
library(zoo)
library(ggplot2)
library(hrbrthemes)
library(gridExtra)
library(grid)
library(ggfortify)

raw_data <- read.csv("Gold Historical Prices.csv", header=TRUE,sep=";")

#data preprocessing: keep dates, day and price column
data_pre <- data.frame(raw_data[,1:3])
colnames(data_pre)[1] <-"Date"
#convert Price column to number
data_pre$Price <-as.numeric(data_pre$Price)

#create a date table to merge and see which days are without price in actual data
dates_table <- data.frame(seq(as.Date("1979-12-27"), by = "day", length.out = 14204))
colnames(dates_table) <-"Date"
dates_table$Day <- weekdays(as.Date(dates_table$Date))
dates_table$Price <- NA
dates_table$Date2 <- as.character(dates_table$Date)

#Get the prices in the complete dates table
dates_table$Price[match(data_pre$Date,dates_table$Date2)] <- data_pre$Price


drop <- "Date2"
dates_table <- dates_table[,!(names(dates_table) %in% drop)]

data_pre2 <-dates_table

#number of missing dates and Prices
Number_of_Missing_Values <- sum(is.na(data_pre2$Price))

#add Year, Month Columns to replace NA Prices with Mean of Week of non zero values
data_pre2$Year <- format(data_pre2$Date, format = "%Y")
data_pre2$Month <- months(data_pre2$Date)
data_pre2$Week <- format(data_pre2$Date, format = "%V")

#create the avg price per week table
temp_table <-data_pre2
temp_table[is.na(temp_table)] <- 0

AVG_Price_perWeek_table <- temp_table %>% group_by(Year,Week) %>%filter(Price != 0) %>% summarise(value=mean(Price)) 
colnames(AVG_Price_perWeek_table)[3] <-"Price"

# add the avg price per week in na for final dataframe
data_final <-left_join(data_pre2, AVG_Price_perWeek_table, by = c("Year","Week")) %>% 
  mutate(Price = ifelse(is.na(Price.x), Price.y, Price.x)) %>% 
  select(Date, Day, Price, Year, Month, Week)

#find if any NA are still existing and replace with adjacent values
Number_of_Missing_Values_Final <- sum(is.na(data_final$Price))
data_final <- na.locf(data_final)

#find mean
mean(data_final$Price)
#find standard deviation
sd(data_final$Price)

summary(data_final)

#par(mfrow = c(1,1))

price_over_time_plot <- ggplot(data_final, aes(x=Date, y=Price)) +
  geom_line( color="#69b3a2") + theme_ipsum() +
  xlab("") +
  theme_ipsum() +
  theme(axis.text.x=element_text(angle=90, hjust=1))+
  scale_x_date(date_breaks = "1 year",date_labels = "%Y")
price_over_time_plot + labs(title = "Price Over Time",x="Year")

#Get AVG Price per Day
AVG_Price_perDay_table <- data_final %>% group_by(Day) %>%filter(Price != 0,Day !="Σάββατο", Day !="Κυριακή") %>% summarise(value=mean(Price))
colnames(AVG_Price_perDay_table)[2] <-"AVG.Price"

grid.table(AVG_Price_perDay_table)

AVG_Price_perDay_table %>% ggplot() +geom_point(aes(x=Day, y=AVG.Price))+ labs(title = "AVG Price per Day",x="Day")

#read data


gold <- data_final %>% group_by(Year,Month) %>%filter(Year >= 2014) %>%filter(Year <= 2018) %>% summarise(value=mean(Price))
colnames(gold)[3] <-"AVG.Price"
plot(gold$AVG.Price, type="l")
grid(col = "lightgray", lty = "dotted")

#check tha daa for NAs
summary(gold)
#separate the data
gold_avg.prices<-gold$AVG.Price

goldtimeseries <- ts(gold_avg.prices, frequency=12, start=c(2014,01))
#see the times series
goldtimeseries
#decompose the time series
goldtimeseriescomponents<-stl(goldtimeseries, s.window="periodic")
plot(goldtimeseriescomponents)

#the arima command unlike  the previous does not take confidence intervals
#while running the algorithm. for auto.arima the confidence levels go to forecast command
f.arima<-auto.arima(goldtimeseries, D=1, trace = TRUE, approximation = FALSE,allowdrift = T,allowmean = T)
summary(f.arima)

f.arima_fitted<-f.arima$fitted
predict_gold_arima<-forecast(f.arima,h=12, level=c(95,99))
hist(residuals(predict_gold_arima))
predict_gold_arima
plot(predict_gold_arima, type="l", col = "black",  showgap = FALSE)
#lines do plot over plot but first there must be a plot
lines(f.arima$fitted, lty=2, col="red")
#legend at position (x,y)=(1988,80000)
legend(x=2014, y=80000, legend=c("data", "fitted"),
       col=c("black", "red"), lty=1:2,cex = 0.8)
grid(col = "lightgray", lty = "dotted")

