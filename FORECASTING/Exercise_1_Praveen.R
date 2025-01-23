# Load required packages
library(dplyr)
library(readr)
library(forecast)
library(fpp2)

# Set working directory
setwd("C:/_BigDataCourses/0976_Forecasting/Forecasting Exam Assignment 2024-20240307/") # Specify your own working directory here.

# Read the CSV file
EU_TripData <- read_csv("EU_trip_expenditures.csv")

# Aggregate data to calculate average expenditure per month
agg_data <- EU_TripData %>%
  group_by(year, month) %>%
  summarise(avg_exp_ngt = mean(avg_exp_ngt))

# Convert to time series
eu_trip_Data <- ts(agg_data$avg_exp_ngt, frequency = 12, start = c(2012, 1))

# Split data into train, test, and remaining sets
eu_train_data <- window(eu_trip_Data, end = c(2017, 3))
eu_test_data <- window(eu_trip_Data, start = c(2017, 4), end = c(2020, 3))
eu_covid_data <- window(eu_trip_Data, start = c(2020, 4), end = c(2022, 12))

# Rename variables
colnames_list <- c("TrainData", "TestData", "CovidData")
list_data <- list(eu_train_data, eu_test_data, eu_covid_data)

for (i in seq_along(list_data)) {
  names(list_data)[i] <- colnames_list[i]
}

# Check the length of test data
length(eu_train_data)

#===============================================================================
# Question 1: Exploratory Data Analysis

# Display time series plot
tsdisplay(eu_train_data)

# Display seasonal plot
seasonplot(eu_train_data, year.labels=TRUE, year.labels.left=TRUE,
           main="Seasonal plot: Europe Trip Expenditures",
           ylab="Consumption expenditure", col=rainbow(20), pch=19)

# Display seasonal subseries plot
monthplot(eu_train_data, ylab="Europe Trip Expenditures", xlab="Month", type="l",
          main="Monthplot: Europe Trip Expenditures")


# 1. Differencing (if necessary)
#ts_diff <- diff(eu_train_data)

# STL decomposition
stlf_decomp <- stl(eu_train_data, s.window = "periodic")
eu_train_data_decomp <- seasadj(stlf_decomp)
# Plot the decomposition
plot(decomposed)
plot(eu_train_data_decomp)


#===============================================================================
# Question 2: Transformation


# Perform the Augmented Dickey-Fuller test
adf_result <- adf.test(eu_train_data)

# Print the results
print(adf_result)
# Display time series plot
tsdisplay(eu_train_data)


# Check if Box-Cox transformation is necessary
lambda <- BoxCox.lambda(eu_train_data)
if (lambda != 1) {
    # Apply Box-Cox transformation
    eu_train_data <- BoxCox(eu_train_data, lambda = lambda)
}

# Check the transformed data
plot(eu_train_data)

# Summary of the differenced time series data
#summary(ts_diff)

# Summary of the seasonally adjusted time series data
summary(eu_train_data)



# Assume your time series data is stored in a variable called 'ts_data'
# Replace 'ts_data' with the name of your actual time series variable
BoxCox.lambda(eu_train_data)

#===============================================================================
# Question 3: Seasonal Naive Forecasting
# 
# # Generate forecasts using the seasonal naive method
# sna <- snaive(eu_train_data, h=length(eu_test_data))
# sna_forecast <- forecast(sna, h=length(eu_test_data))
# 
# # Check residual diagnostics
# checkresiduals(sna)
# 
# # Display forecast accuracy
# accuracy(sna_forecast, eu_test_data)
# 
# # Plot forecast
# plot(sna_forecast)
# lines(eu_test_data)
# 

sna <- snaive(eu_train_data, h=length(eu_test_data))
sna_forecast <- forecast(sna, h=length(eu_test_data))
sna_accuracy <- accuracy(sna_forecast, eu_test_data)
sna_residuals <- checkresiduals(sna)
sna_residuals
sna_accuracy
plot(sna_forecast)
lines(eu_test_data)
# Display time series diagnostics
tsdisplay(eu_train_data)


sna_mean <- meanf(eu_train_data, h=length(eu_test_data))
sna_mean_forecast <- forecast(sna_mean, h=length(eu_test_data))
sna_mean_residuals <- checkresiduals(sna_mean)
sna_mean_accuracy <- accuracy(sna_mean_forecast, eu_test_data)
sna_mean_residuals
sna_mean_accuracy
plot(sna_mean_forecast)
lines(eu_test_data)

sna_naive <- rwf(eu_train_data, h=length(eu_test_data))
sna_naive_forecast <- forecast(sna_naive, h=length(eu_test_data))
sna_naive_residuals <- checkresiduals(sna_naive)
sna_naive_accuracy <- accuracy(sna_naive_forecast, eu_test_data)
sna_naive_residuals
sna_naive_accuracy
plot(sna_naive_forecast)
lines(eu_test_data)


sna_drift <- rwf(eu_train_data, drift=TRUE, h=length(eu_test_data))
sna_drift_forecast <- forecast(sna_drift, h=length(eu_test_data))
sna_drift_accuracy <- accuracy(sna_drift_forecast, eu_test_data)
sna_drift_residuals <- checkresiduals(sna_drift)
sna_drift_residuals
sna_drift_accuracy
plot(sna_drift_forecast)
lines(eu_test_data)


# Fit STL Naive Log model
stlf_naive_log <- stlf(eu_train_data, method = "naive", h = length(eu_test_data), transform = TRUE)
stlf_naive_log_forecast <- forecast(stlf_naive_log, h=length(eu_test_data))
stlf_naive_log_residuals <- checkresiduals(stlf_naive_log)
stlf_naive_log_accuracy <- accuracy(stlf_naive_log_forecast, eu_test_data)
stlf_naive_log_residuals
stlf_naive_log_accuracy
plot(stlf_naive_log_forecast)
lines(eu_test_data)

# Create accuracy and residual table
accuracy_residual_table <- data.frame(
  Model = c("Seasonal Naive", "Mean", "Naive", "Random Walk with Drift", "STL Naive Log"),
  RMSE = c(sna_accuracy[2], sna_mean_accuracy[2], sna_naive_accuracy[2], sna_drift_accuracy[2], stlf_naive_log_accuracy[2]),
  MAE = c(sna_accuracy[3], sna_mean_accuracy[3], sna_naive_accuracy[3], sna_drift_accuracy[3], stlf_naive_log_accuracy[3]),
  MAPE = c(sna_accuracy[5], sna_mean_accuracy[5], sna_naive_accuracy[5], sna_drift_accuracy[5], stlf_naive_log_accuracy[5]),
  Ljung_Box_p_value = c(NA, NA, NA, NA, NA)
)

# Print accuracy and residual table
print(accuracy_residual_table)

library(gridExtra)

# Plot each model separately
plot_sna <- autoplot(sna_forecast) + ggtitle("SNA Forecast")
plot_sna_mean <- autoplot(sna_mean_forecast) + ggtitle("Mean Forecast")
plot_sna_naive <- autoplot(sna_naive_forecast) + ggtitle("Naive Forecast")
plot_sna_drift <- autoplot(sna_drift_forecast) + ggtitle("Drift Forecast")
plot_stlf_naive_log <- autoplot(stlf_naive_log_forecast) + ggtitle("STL Naive Log Forecast")

# Arrange plots in a matrix layout
grid.arrange(plot_sna, plot_sna_mean, plot_sna_naive, plot_sna_drift, plot_stlf_naive_log, ncol = 2)

#####
# 
# library(forecast)
# 
# # Function to fit a model and perform forecast
# fit_forecast_model <- function(train_data, test_data, model_name, model_function, ...) {
#   model <- model_function(train_data, ...)
#   forecast_result <- forecast(model, h = length(test_data))
#   return(list(model = model, forecast = forecast_result))
# }
# 
# # Function to check residuals and extract accuracy metrics
# check_residuals_accuracy <- function(model, test_data) {
#   residuals <- checkresiduals(model$model)
#   accuracy_metrics <- accuracy(model$forecast, test_data)[, c(2, 3, 5, 6)]
#   return(list(residuals = residuals, accuracy_metrics = accuracy_metrics))
# }
# 
# # Fit and forecast models
# models <- list(
#   Seasonal_Naive = list(model_function = snaive),
#   Mean = list(model_function = meanf),
#   Naive = list(model_function = rwf),
#   Drift = list(model_function = function(train_data, ...) rwf(train_data, drift = TRUE, ...)),
#   stlf_Naive_Log = list(model_function = function(train_data, ...) stlf(train_data, method = "naive", transform = TRUE, ...))
# )
# 
# results <- list()
# 
# for (model_name in names(models)) {
#   model_info <- models[[model_name]]
#   model_fit_forecast <- fit_forecast_model(eu_train_data, eu_test_data, model_name, model_info$model_function)
#   residuals_accuracy <- check_residuals_accuracy(model_fit_forecast, eu_test_data)
#   
#   results[[model_name]] <- list(
#     model = model_fit_forecast$model,
#     forecast = model_fit_forecast$forecast,
#     residuals = residuals_accuracy$residuals,
#     accuracy = residuals_accuracy$accuracy_metrics
#   )
# }
# 
# # Create accuracy and residual table
# accuracy_residual_table <- data.frame(
#   Model = names(results),
#   RMSE = sapply(results, function(x) x$accuracy[1]),
#   MAE = sapply(results, function(x) x$accuracy[2]),
#   MAPE = sapply(results, function(x) x$accuracy[3]),
#   Ljung_Box_p_value = sapply(results, function(x) x$residuals$statistics[3]),
#   Q_value = sapply(results, function(x) x$residuals$statistics[1]),
#   Degrees_of_Freedom = sapply(results, function(x) x$residuals$statistics[2])
# )
# 
# # Print the accuracy and residual table
# print(accuracy_residual_table)

#===============================================================================
# Question 4: STL Decomposition


# 2. Seasonal Adjustment (STL Decomposition)
# Check if differencing is required before STL decomposition
# if (var(ts_diff) > 0.05) {  # Adjust threshold as needed
#   stlf_decomp <- stl(ts_diff, s.window = "periodic")
# } else {
#   stlf_decomp <- stl(eu_train_data, s.window = "periodic")
# }
# eu_train_data <- seasadj(stlf_decomp)
# 
# # Decomposition to identify components
# decomposed <- stl(eu_train_data, s.window = "periodic")
# plot(decomposed)

# 
# decompose_model <- mstl(eu_train_data) #decompose
# eu_train_data_adj <- seasadj(decompose_model)
# plot(snaive(eu_train_data_adj, h=24, drift = TRUE), ylim =c(0, 2200))
# 
# # STL decomposition and forecasting
# stlf_ets <- stlf(eu_train_data, method="ets", h=length(eu_test_data))
# stlf_ets_forecast <- forecast(stlf_ets, h=length(eu_test_data))
# 
# # Check residual diagnostics
# checkresiduals(stlf_ets)
# 
# # Display forecast accuracy
# accuracy(stlf_ets_forecast, eu_test_data)
# 
# # Plot forecast
# plot(stlf_ets_forecast)
# lines(eu_test_data)
############

stlf_decomp <- stl(eu_train_data, s.window = "periodic")
eu_train_data_decomp <- seasadj(stlf_decomp)

# Seasonal Naive Method
#sna_STL <- snaive(eu_train_data)
#sna_forecast <- forecast(sna, h = length(eu_test_data))
# Plot actual vs. forecasted for Seasonal Naive Method
checkresiduals(sna)
accuracy(sna_forecast, eu_test_data)
plot(sna_forecast, main = "Seasonal Naive Method", xlab = "Time", ylab = "Expenditures")
lines(eu_test_data, col = "blue")


# Random Walk with Drift
# sna_drift <- rwf(eu_train_data, drift = TRUE)
# sna_drift_forecast <- forecast(sna_drift, h = length(eu_test_data))
# Plot actual vs. forecasted for Random Walk with Drift
checkresiduals(sna_drift)
accuracy(sna_drift_forecast, eu_test_data)
plot(sna_drift_forecast, main = "Random Walk with Drift", xlab = "Time", ylab = "Expenditures")
lines(eu_test_data, col = "blue")



# STL ETS
stlf_ets <- stlf(eu_train_data_decomp, method = "ets", h = length(eu_test_data))
stlf_ets_forecast <- forecast(stlf_ets)
stlf_ets_residuals <- checkresiduals(stlf_ets)
checkresiduals(stlf_ets)
accuracy(stlf_ets_forecast, eu_test_data)
# Plot actual vs. forecasted for STL ETS
plot(stlf_ets_forecast, main = "STL ETS", xlab = "Time", ylab = "Expenditures")
lines(eu_test_data, col = "blue")

# STL ARIMA
stlf_arima <- stlf(eu_train_data_decomp, method = "arima", h = length(eu_test_data))
stlf_arima_forecast <- forecast(stlf_arima)
stlf_arima_residuals <- checkresiduals(stlf_arima)
checkresiduals(stlf_arima)
accuracy(stlf_arima_forecast, eu_test_data)
# Plot actual vs. forecasted for STL ARIMA
plot(stlf_arima_forecast, main = "STL ARIMA", xlab = "Time", ylab = "Expenditures")
lines(eu_test_data, col = "blue")


# STL Naive Log
stlf_naive_log <- stlf(log(eu_train_data_decomp), method = "naive", h = length(eu_test_data))
stlf_naive_log_forecast <- forecast(stlf_naive_log)
stlf_naive_log_residuals <- checkresiduals(stlf_naive_log)
checkresiduals(stlf_naive_log)
accuracy(stlf_naive_log_forecast, eu_test_data)
# Plot actual vs. forecasted for STL Naive Log
plot(stlf_naive_log_forecast, main = "STL Naive Log", xlab = "Time", ylab = "Expenditures")
lines(eu_test_data, col = "blue")


# STL RW Drift Log
stlf_rwdrift_log <- stlf(log(eu_train_data_decomp), method = "rwdrift", h = length(eu_test_data))
stlf_rwdrift_log_forecast <- forecast(stlf_rwdrift_log)
stlf_rwdrift_log_residuals <- checkresiduals(stlf_rwdrift_log)
checkresiduals(stlf_rwdrift_log)
accuracy(stlf_rwdrift_log_forecast, eu_test_data)
# Plot actual vs. forecasted for STL RW Drift Log
plot(stlf_rwdrift_log_forecast, main = "STL RW Drift Log", xlab = "Time", ylab = "Expenditures")
lines(eu_test_data, col = "blue")

# STL ETS Log
stlf_ets_log <- stlf(log(eu_train_data_decomp), method = "ets", h = length(eu_test_data))
stlf_ets_log_forecast <- forecast(stlf_ets_log)
stlf_ets_log_residuals <- checkresiduals(stlf_ets_log)
checkresiduals(stlf_ets_log)
accuracy(stlf_ets_log_forecast, eu_test_data)
# Plot actual vs. forecasted for STL ETS Log
plot(stlf_ets_log_forecast, main = "STL ETS Log", xlab = "Time", ylab = "Expenditures")
lines(eu_test_data, col = "blue")

# STL ARIMA Log
stlf_arima_log <- stlf(log(eu_train_data_decomp), method = "arima", h = length(eu_test_data))
stlf_arima_log_forecast <- forecast(stlf_arima_log)
stlf_arima_log_residuals <- checkresiduals(stlf_arima_log)
checkresiduals(stlf_arima_log)
accuracy(stlf_arima_log_forecast, eu_test_data)
# Plot actual vs. forecasted for STL ARIMA Log
plot(stlf_arima_log_forecast, main = "STL ARIMA Log", xlab = "Time", ylab = "Expenditures")
lines(eu_test_data, col = "blue")




# Combine accuracy, residuals, AIC, and BIC into a single table
# accuracy_residual_table <- data.frame(
#   Model = c("Seasonal Naive", "Random Walk with Drift", "STL ETS", "STL ARIMA", "STL Naive Log", "STL RW Drift Log", "STL ETS Log", "STL ARIMA Log"),
#   RMSE = c(accuracy(sna_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(sna_drift_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_ets_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_arima_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_naive_log_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_rwdrift_log_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_ets_log_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_arima_log_forecast, eu_test_data)[2, "RMSE"]),
#   MAE = c(accuracy(sna_forecast, eu_test_data)[2, "MAE"],
#           accuracy(sna_drift_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_ets_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_arima_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_naive_log_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_rwdrift_log_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_ets_log_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_arima_log_forecast, eu_test_data)[2, "MAE"]),
#   MAPE = c(accuracy(sna_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(sna_drift_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_ets_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_arima_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_naive_log_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_rwdrift_log_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_ets_log_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_arima_log_forecast, eu_test_data)[2, "MAPE"]),
#     Ljung_Box_q = c(sna_residuals$statistic, 
#                         sna_drift_residuals$statistic, 
#                         stlf_ets_residuals$statistic, 
#                         stlf_arima_residuals$statistic, 
#                         stlf_naive_log_residuals$statistic,
#                         stlf_rwdrift_log_residuals$statistic, 
#                         stlf_ets_log_residuals$statistic, 
#                         stlf_arima_log_residuals$statistic),
#     Ljung_Box_df = c(sna_residuals$parameter, 
#                         sna_drift_residuals$parameter, 
#                         stlf_ets_residuals$parameter, 
#                         stlf_arima_residuals$parameter, 
#                         stlf_naive_log_residuals$parameter,
#                         stlf_rwdrift_log_residuals$parameter, 
#                         stlf_ets_log_residuals$parameter, 
#                         stlf_arima_log_residuals$parameter),
#       Ljung_Box_p_value = c(sna_residuals$p.value, 
#                         sna_drift_residuals$p.value, 
#                         stlf_ets_residuals$p.value, 
#                         stlf_arima_residuals$p.value, 
#                         stlf_naive_log_residuals$p.value,
#                         stlf_rwdrift_log_residuals$p.value, 
#                         stlf_ets_log_residuals$p.value, 
#                         stlf_arima_log_residuals$p.value)
#   #AIC = c(AIC_AAN, AIC_ANN, AIC_AAA, AIC_MMM, AIC_MAM),
#   #BIC = c(BIC_AAN, BIC_ANN, BIC_AAA, BIC_MMM, BIC_MAM)
# )
# 
# # Print the combined table
# print(accuracy_residual_table)

# *********
# 
# # Calculate residuals for each model
# sna_residuals <- checkresiduals(sna)
# sna_drift_residuals <- checkresiduals(sna_drift)
# stlf_ets_residuals <- checkresiduals(stlf_ets)
# stlf_arima_residuals <- checkresiduals(stlf_arima)
# stlf_naive_log_residuals <- checkresiduals(stlf_naive_log)
# stlf_rwdrift_log_residuals <- checkresiduals(stlf_rwdrift_log)
# stlf_ets_log_residuals <- checkresiduals(stlf_ets_log)
# stlf_arima_log_residuals <- checkresiduals(stlf_arima_log)
# 
# sna_residuals 
# sna_drift_residuals 
# stlf_ets_residuals 
# stlf_arima_residuals 
# stlf_naive_log_residuals 
# stlf_rwdrift_log_residuals 
# stlf_ets_log_residuals 
# stlf_arima_log_residuals 
# 
# 
# sna_residuals$statistic
# sna_residuals$parameter
# sna_residuals$p.value
# 
# # Combine accuracy, residuals, AIC, and BIC into a single table
# accuracy_residual_table <- data.frame(
#   Model = c("Seasonal Naive", "Random Walk with Drift", "STL ETS", "STL ARIMA", 
#             "STL Naive Log", "STL RW Drift Log", "STL ETS Log", "STL ARIMA Log"),
#   RMSE = c(accuracy(sna_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(sna_drift_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_ets_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_arima_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_naive_log_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_rwdrift_log_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_ets_log_forecast, eu_test_data)[2, "RMSE"],
#            accuracy(stlf_arima_log_forecast, eu_test_data)[2, "RMSE"]),
#   MAE = c(accuracy(sna_forecast, eu_test_data)[2, "MAE"],
#           accuracy(sna_drift_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_ets_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_arima_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_naive_log_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_rwdrift_log_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_ets_log_forecast, eu_test_data)[2, "MAE"],
#           accuracy(stlf_arima_log_forecast, eu_test_data)[2, "MAE"]),
#   MAPE = c(accuracy(sna_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(sna_drift_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_ets_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_arima_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_naive_log_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_rwdrift_log_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_ets_log_forecast, eu_test_data)[2, "MAPE"],
#            accuracy(stlf_arima_log_forecast, eu_test_data)[2, "MAPE"]),
#   Ljung_Box_q = c(sna_residuals$statistic, 
#                   sna_drift_residuals$statistic, 
#                   stlf_ets_residuals$statistic, 
#                   stlf_arima_residuals$statistic, 
#                   stlf_naive_log_residuals$statistic,
#                   stlf_rwdrift_log_residuals$statistic, 
#                   stlf_ets_log_residuals$statistic, 
#                   stlf_arima_log_residuals$statistic),
#   Ljung_Box_df = c(sna_residuals$parameter, 
#                    sna_drift_residuals$parameter, 
#                    stlf_ets_residuals$parameter, 
#                    stlf_arima_residuals$parameter, 
#                    stlf_naive_log_residuals$parameter,
#                    stlf_rwdrift_log_residuals$parameter, 
#                    stlf_ets_log_residuals$parameter, 
#                    stlf_arima_log_residuals$parameter),
#   Ljung_Box_p_value = c(sna_residuals$p.value, 
#                         sna_drift_residuals$p.value, 
#                         stlf_ets_residuals$p.value, 
#                         stlf_arima_residuals$p.value, 
#                         stlf_naive_log_residuals$p.value,
#                         stlf_rwdrift_log_residuals$p.value, 
#                         stlf_ets_log_residuals$p.value, 
#                         stlf_arima_log_residuals$p.value)
# )
# 
# # Print the combined table
# print(accuracy_residual_table)

#===============================================================================
# Question 5: ETS Models

# Fit and forecast using ETS(A,A,N) model
ets_ANA <- ets(eu_train_data_decomp, model = "ANA")
ets_ANA_forecast <- forecast(ets_ANA, h = length(eu_test_data))
checkresiduals(ets_ANA)
accuracy(ets_ANA_forecast, eu_test_data)
AIC(ets_ANA)
BIC(ets_ANA)
# Plot forecast
plot(ets_ANA_forecast)
lines(eu_test_data)

# Fit and forecast using ETS(A,A,N) model
ets_MNN <- ets(eu_train_data_decomp, model = "MNN")
ets_MNN_forecast <- forecast(ets_MNN, h = length(eu_test_data))
checkresiduals(ets_MNN)
accuracy(ets_MNN_forecast, eu_test_data)
AIC(ets_MNN)
BIC(ets_MNN)
# Plot forecast
plot(ets_MNN_forecast)
lines(eu_test_data)

# Fit and forecast using ETS(A,A,N) model
ets_AAN <- ets(eu_train_data_decomp, model = "AAN")
ets_AAN_forecast <- forecast(ets_AAN, h = length(eu_test_data))
checkresiduals(ets_AAN)
accuracy(ets_AAN_forecast, eu_test_data)
AIC_AAN <- AIC(ets_AAN)
BIC_AAN <- BIC(ets_AAN)
# Plot forecast
plot(ets_AAN_forecast)
lines(eu_test_data)

# Fit and forecast using ETS(A,N,N) model
ets_ANN <- ets(eu_train_data_decomp, model = "ANN")
ets_ANN_forecast <- forecast(ets_ANN, h = length(eu_test_data))
checkresiduals(ets_ANN)
accuracy(ets_ANN_forecast, eu_test_data)
AIC(ets_ANN)
BIC(ets_ANN)
# Plot forecast
plot(ets_ANN_forecast)
lines(eu_test_data)

# Fit and forecast using ETS(A,A,A) model
ets_AAA <- ets(eu_train_data_decomp, model = "AAA")
ets_AAA_forecast <- forecast(ets_AAA, h = length(eu_test_data))
checkresiduals(ets_AAA)
accuracy(ets_AAA_forecast, eu_test_data)
AIC(ets_AAA)
BIC(ets_AAA)
# Plot forecast
plot(ets_AAA_forecast)
lines(eu_test_data)

# Fit and forecast using ETS(M,M,M) model
ets_MMM <- ets(eu_train_data_decomp, model = "MMM")
ets_MMM_forecast <- forecast(ets_MMM, h = length(eu_test_data))
checkresiduals(ets_MMM)
accuracy(ets_MMM_forecast, eu_test_data)
AIC(ets_MMM)
BIC(ets_MMM)
# Plot forecast
plot(ets_MMM_forecast)
lines(eu_test_data)

# Fit and forecast using ETS(M,A,M) model
ets_MAM <- ets(eu_train_data_decomp, model = "MAM")
ets_MAM_forecast <- forecast(ets_MAM, h = length(eu_test_data))
checkresiduals(ets_MAM)
accuracy(ets_MAM_forecast, eu_test_data)
AIC(ets_MAM)
BIC(ets_MAM)
# Plot forecast
plot(ets_MAM_forecast)
lines(eu_test_data)

# ETS(A,N,N) 10.83800  9.474163  8.724209         0.8343183 420.7638 427.1932 
# ETS(A,N,N) being a good choice if we consider model simplicity and goodness of fit.
accuracy(ets_MAM_forecast, eu_test_data)
# Display summary of the ETS(M,M,M) model
summary(ets_MMM)


#===============================================================================
# Question 6: ARIMA Models

# Fit and forecast using auto.arima
arima_auto <- auto.arima(eu_train_data_decomp)
arima_auto_forecast <- forecast(arima_auto, h = length(eu_test_data))

# Summary of the ARIMA model
summary(arima_auto)

# Extract coefficients
coefficients <- coef(arima_auto)

# Print coefficients
print(coefficients)

# Check residual diagnostics
checkresiduals(arima_auto)

# Display forecast accuracy
accuracy(arima_auto_forecast, eu_test_data)

# Plot forecast
plot(arima_auto_forecast)
lines(eu_test_data)
tsdisplay(eu_train_data_decomp)




#
#Manual ARIMA 012
#
arima_012 <- arima(eu_train_data_decomp, order = c(0, 1, 2), method = "CSS-ML")
arima_012_forecast <- forecast(arima_012, h = length(eu_test_data))
#Check residual diagnostics
checkresiduals(arima_012)
#Display forecast accuracy
accuracy(arima_012_forecast, eu_test_data)
#Plot forecast
plot(arima_012_forecast)
lines(eu_test_data)
#
#Manual ARIMA 110
#
arima_110 <- arima(eu_train_data_decomp, order = c(1, 1, 0), method = "CSS-ML")
arima_110_forecast <- forecast(arima_110, h = length(eu_test_data))
#Check residual diagnostics
checkresiduals(arima_110)
#Display forecast accuracy
accuracy(arima_110_forecast, eu_test_data)
#Plot forecast
plot(arima_110_forecast)
lines(eu_test_data)
#Manual ARIMA 111
#
arima_111 <- arima(eu_train_data_decomp, order = c(1, 1, 1), method = "CSS-ML")
arima_111_forecast <- forecast(arima_111, h = length(eu_test_data))
#Check residual diagnostics
checkresiduals(arima_111)
#Display forecast accuracy
accuracy(arima_111_forecast, eu_test_data)
#Plot forecast
plot(arima_111_forecast)
lines(eu_test_data)
#
#
#Manual ARIMA 112
#
arima_112 <- arima(eu_train_data_decomp, order = c(1, 1, 2), method = "CSS-ML")
arima_112_forecast <- forecast(arima_112, h = length(eu_test_data))
#Check residual diagnostics
checkresiduals(arima_112)
#Display forecast accuracy
accuracy(arima_112_forecast, eu_test_data)
#Plot forecast
plot(arima_112_forecast)
lines(eu_test_data)
#



# Manual ARIMA 011 101
#
arima_011_101 <- arima(eu_train_data_decomp, order = c(0, 1, 1), seasonal = list(order = c(1, 0, 1), period = 12))
arima_011_101_forecast <- forecast(arima_011_101, h = length(eu_test_data))
#Check residual diagnostics
checkresiduals(arima_011_101)
#Display forecast accuracy
accuracy(arima_011_101_forecast, eu_test_data)
#Plot forecast
plot(arima_011_101_forecast)
lines(eu_test_data)
#
#Manual ARIMA 011 011
#
arima_011_011 <- arima(eu_train_data_decomp, order = c(0, 1, 1), seasonal = list(order = c(0, 1, 1), period = 12))
arima_011_011_forecast <- forecast(arima_011_011, h = length(eu_test_data))
#Check residual diagnostics
checkresiduals(arima_011_011)
#Display forecast accuracy
accuracy(arima_011_011_forecast, eu_test_data)
#Plot forecast
plot(arima_011_011_forecast)
lines(eu_test_data)

# Manual ARIMA 011

arima_011 <- arima(eu_train_data_decomp, order = c(0, 1, 1), seasonal = list(order = c(1, 1, 1), period = 12))
arima_011_forecast <- forecast(arima_011, h = length(eu_test_data))

# Check residual diagnostics
checkresiduals(arima_011)

# Display forecast accuracy
accuracy(arima_011_forecast, eu_test_data)

# Plot forecast
plot(arima_011_forecast)
lines(eu_test_data)

summary(arima_011)
# Manual ARIMA 111 111

arima_111_111 <- arima(eu_train_data_decomp, order = c(1, 1, 1), seasonal = list(order = c(1, 1, 1), period = 12))
arima_111_111_forecast <- forecast(arima_111_111, h = length(eu_test_data))

# Check residual diagnostics
checkresiduals(arima_111_111)

# Display forecast accuracy
accuracy(arima_111_111_forecast, eu_test_data)

# Plot forecast
plot(arima_111_111_forecast)
lines(eu_test_data)

#############
#ARIMA(0,1,1)(1,1,1)[12] seems to be the best model
#===============================================================================
# Question 7: Model Comparison

# Initialize an empty data frame to store results
accuracy_table <- data.frame(Model = character(), 
                             RMSE = numeric(),
                             MAE = numeric(),
                             MAPE = numeric(),
                             MASE = numeric(),
                             stringsAsFactors = FALSE)

# Function to calculate accuracy and append to the accuracy_table
calculate_accuracy <- function(forecast_result, model_name) {
  accuracy_values <- accuracy(forecast_result, eu_test_data)[2, c(2, 3, 5, 6)]
  row <- c(model_name, accuracy_values)
  return(row)
}

# Add models to the accuracy table
accuracy_table <- rbind(accuracy_table, calculate_accuracy(sna_forecast, "Seasonal Naive"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(stlf_naive_forecast, "STL (Naive)"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(stlf_rwdrift_forecast, "STL (RW Drift)"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(stlf_ets_forecast, "STL (ETS)"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(stlf_arima_forecast, "STL (ARIMA)"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(ets_ANA_forecast, "ETS (ANA)"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(ets_AAN_forecast, "ETS (AAN)"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(ets_AAN_auto_forecast, "ETS (AAN) Auto"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(ets_AAN_damped_forecast, "ETS (AAN) Damped"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(ets_AAN_undamped_forecast, "ETS (AAN) Undamped"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(arima_auto_forecast, "Auto ARIMA"))
accuracy_table <- rbind(accuracy_table, calculate_accuracy(arima_606_forecast, "Manual ARIMA (6,0,6)"))


accuracy_table <- rbind(accuracy_table, calculate_accuracy(arima_auto_forecast, "AutoARIMA"))

# Add additional models similarly

# Add header to the accuracy table
colnames(accuracy_table) <- c("Model", "RMSE", "MAE", "MAPE", "MASE")

# Print the accuracy table
print(accuracy_table)

#===============================================================================
# Question 8: Out-of-Sample Forecasting

eu_sample_data <- window(eu_trip_Data, end = c(2020, 3))

# Fit the ARIMA model with seasonal component using the complete time series data
arima_sample_111 <- arima(eu_sample_data, order = c(1, 1, 1), seasonal = list(order = c(1, 1, 1), period = 12))

# Generate forecasts for the next 12 time periods
arima_sample_111_forecast <- forecast(arima_sample_111, h = 12)

# Print the forecasted values
print(arima_sample_111_forecast)

# Plot the forecasted values
plot(arima_sample_111_forecast)

#===============================================================================
# Question 9: Impact of COVID-19

# Fit the ARIMA model with seasonal component using the complete time series data
arima_final_covid <- arima(eu_covid_data, order = c(1, 1, 1), seasonal = list(order = c(1, 1, 1), period = 12))

# Generate forecasts for the next 12 time periods
arima_final_covid_forecast <- forecast(arima_final_covid, h = 12)

# Plot actual vs. forecasted data
plot(arima_final_covid_forecast, main = "Actual vs. Forecasted Travel Expenditures in EU", xlab = "Time", ylab = "Travel Expenditures")

