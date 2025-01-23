# Load required packages
library(dplyr)
library(readr)
library(forecast)
library(fpp2)
library(gridExtra)


# Set working directory
setwd("C:/_BigDataCourses/0976_Forecasting/Forecasting Exam Assignment 2024-20240307/") # Specify your own working directory here.

# Read the CSV file
EU_TripData <- read_csv("crudeOilDataset.csv")

# Aggregate data to calculate average expenditure per month
agg_crudeOil_Data <- crudeOil_Data %>%
  group_by(Month) %>%
  summarise(Oil_tbpd = mean(Oil_tbpd))

# Convert to time series
crudeOil_Data_ts <- ts(agg_crudeOil_Data$Oil_tbpd, frequency = 12, start = c(2007, 1))

# Split data into train, test, and remaining sets
oil_train_data <- window(crudeOil_Data_ts, end = c(2017, 12))
oil_test_data <- window(crudeOil_Data_ts, start = c(2018, 1), end = c(2020, 12))
eu_covid_data <- window(crudeOil_Data_ts, start = c(2021, 1), end = c(2022, 12))

# Rename variables
colnames_list <- c("TrainData", "TestData", "CovidData")
list_data <- list(oil_train_data, oil_test_data, eu_covid_data)

for (i in seq_along(list_data)) {
  names(list_data)[i] <- colnames_list[i]
}

# Check the length of test data
length(oil_train_data)

#===============================================================================
# Question 1: Exploratory Data Analysis

# Display time series plot
tsdisplay(oil_train_data)

# Display seasonal plot
seasonplot(oil_train_data, year.labels=TRUE, year.labels.left=TRUE,
           main="Seasonal plot: Crude Oil Production",
           col=rainbow(20), pch=19)

# Display seasonal subseries plot
monthplot(oil_train_data, xlab="Month", type="l",
          main="Monthplot: Crude Oil Production")


# 1. Differencing (if necessary)
#ts_diff <- diff(oil_train_data)

# STL decomposition
stlf_decomp <- stl(oil_train_data, s.window = "periodic")
oil_train_data_decomp <- seasadj(stlf_decomp)
# Plot the decomposition
plot(decomposed)
plot(oil_train_data_decomp)


#===============================================================================
# Question 2: Transformation

# Perform the Augmented Dickey-Fuller test
adf_result <- adf.test(oil_train_data)

# Print the results
print(adf_result)
# Display time series plot
tsdisplay(oil_train_data)


# Check if Box-Cox transformation is necessary
lambda <- BoxCox.lambda(oil_train_data)
if (lambda != 1) {
    # Apply Box-Cox transformation
    oil_train_data <- BoxCox(oil_train_data, lambda = lambda)
}

# Check the transformed data
plot(oil_train_data)

# Summary of the differenced time series data
#summary(ts_diff)

# Summary of the seasonally adjusted time series data
summary(oil_train_data)
BoxCox.lambda(oil_train_data)


# Assuming `time_series_data` is your time series object
ses_model <- ses(time_series_data, h = 10) # `h` is the forecast horizon

# Plot the forecast
plot(ses_model)




#===============================================================================
# Question 3: Seasonal Naive Forecasting
library(forecast)

# Assuming `oil_train_data` is your train time series object and `oil_test_data` is your test object
# Simple Exponential Smoothing
ses_model <- ses(oil_train_data, h = length(oil_test_data))
plot(ses_model, main = "Simple Exponential Smoothing Forecast")

# Calculate forecast accuracy
ses_accuracy <- accuracy(ses_model, oil_test_data)
print("Simple Exponential Smoothing Forecast Accuracy:")
print(ses_accuracy)

# Check residuals
checkresiduals(ses_model)

# Holt's Linear Trend Method
holt_model <- holt(oil_train_data, h = length(oil_test_data))
plot(holt_model, main = "Holt's Linear Forecast")

# Calculate forecast accuracy
holt_accuracy <- accuracy(holt_model, oil_test_data)
print("Holt's Linear Trend Method Forecast Accuracy:")
print(holt_accuracy)

# Check residuals
checkresiduals(holt_model)

# Holt-Winters' Damped Method with Additive Seasonality
hw_model <- hw(oil_train_data, seasonal = "additive", damped = TRUE, h = length(oil_test_data))
plot(hw_model, main = "Holt-Winters' Damped Forecast with Additive Seasonality")

# Calculate forecast accuracy
hw_accuracy <- accuracy(hw_model, oil_test_data)
print("Holt-Winters' Damped Method Forecast Accuracy:")
print(hw_accuracy)

# Check residuals
checkresiduals(hw_model)



library(gridExtra)
library(ggplot2)

# Generate plots with autoplot
plot_ses <- autoplot(ses_model) + ggtitle("SES Forecast")
plot_holt <- autoplot(holt_model) + ggtitle("Holt's Linear Forecast")
plot_hw <- autoplot(hw_model) + ggtitle("Holt-Winters' Damped Forecast")

# Arrange plots in a grid layout
grid.arrange(plot_ses, plot_holt, plot_hw, ncol = 2)

#===============================================================================
# Question 4: STL Decomposition


stlf_decomp <- stl(oil_train_data, s.window = "periodic")
oil_train_data_decomp <- seasadj(stlf_decomp)

#===============================================================================
# Question 4: ETS Models

# Fit and forecast using ETS(M,M,M) model
ets_MMM <- ets(oil_train_data_decomp, model = "MMM")
ets_MMM_forecast <- forecast(ets_MMM, h = length(oil_test_data))
checkresiduals(ets_MMM)
accuracy(ets_MMM_forecast, oil_test_data)
AIC(ets_MMM)
BIC(ets_MMM)
# Plot forecast
plot(ets_MMM_forecast)
lines(oil_test_data)

#===============================================================================
# Question 5: ARIMA Models

# Fit and forecast using auto.arima
arima_auto <- auto.arima(oil_train_data_decomp)
arima_auto_forecast <- forecast(arima_auto, h = length(oil_test_data))

# Summary of the ARIMA model
summary(arima_auto)

# Extract coefficients
coefficients <- coef(arima_auto)

# Print coefficients
print(coefficients)

# Check residual diagnostics
checkresiduals(arima_auto)

# Display forecast accuracy
accuracy(arima_auto_forecast, oil_test_data)

# Plot forecast
plot(arima_auto_forecast)
lines(oil_test_data)
tsdisplay(oil_train_data_decomp)


# Manual ARIMA 011 101
#
arima_011_101 <- arima(oil_train_data_decomp, order = c(0, 1, 1), seasonal = list(order = c(1, 0, 1), period = 12))
arima_011_101_forecast <- forecast(arima_011_101, h = length(oil_test_data))
#Check residual diagnostics
checkresiduals(arima_011_101)
#Display forecast accuracy
accuracy(arima_011_101_forecast, oil_test_data)
#Plot forecast
plot(arima_011_101_forecast)
lines(oil_test_data)

#===============================================================================
# Question 6: Out-of-Sample Forecasting

eu_sample_data <- window(crudeOil_Data_ts, end = c(2020, 3))

# Fit the ARIMA model with seasonal component using the complete time series data
arima_sample_111 <- arima(eu_sample_data, order = c(0, 1, 1), seasonal = list(order = c(1, 0, 1), period = 12))

# Generate forecasts for the next 12 time periods
arima_sample_111_forecast <- forecast(arima_sample_111, h = 12)

# Print the forecasted values
print(arima_sample_111_forecast)

# Plot the forecasted values
plot(arima_sample_111_forecast)

#===============================================================================
# Question 7: Impact of COVID-19

# Fit the ARIMA model with seasonal component using the complete time series data
arima_final_covid <- arima(eu_covid_data, order = c(0, 1, 1), seasonal = list(order = c(1, 0, 1), period = 12))

# Generate forecasts for the next 12 time periods
arima_final_covid_forecast <- forecast(arima_final_covid, h = 12)

# Plot actual vs. forecasted data
plot(arima_final_covid_forecast, main = "Actual vs. Forecasted")

