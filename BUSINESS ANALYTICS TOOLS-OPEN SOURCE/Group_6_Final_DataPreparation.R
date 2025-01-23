

# Load the packages
library(haven)
library(dplyr)
library(lubridate)
library(readxl)

# Specify the directory path where your SAS file is located
directoryPath <- "C:/_BigDataCourses/0604 OpenSourceProgramming_R/GroupProject/FinalTerm_Work/"

# Specify the file name separately
filePokerChip          <- "RawDataIIIPokerChipConversions.sas7bdat"
fileDemographics       <- "RawDataIDemographics.sas7bdat"
fileUserAggregation    <- "RawDataIIUserDailyAggregation.sas7bdat"

# Read the SAS file using the path and file name
dataSetPokerChip       <- read_sas(paste0(directoryPath, filePokerChip))
dataSetDemographics    <- read_sas(paste0(directoryPath, fileDemographics))
dataSetUserAggregation <- read_sas(paste0(directoryPath, fileUserAggregation))

# Merge Appendix with Datasets:
dataSetUserAggregation <- left_join(dataSetUserAggregation, read_excel(paste0(directoryPath, "AppendixSheet.xlsx"), sheet = "Product"), by = "ProductID")
dataSetDemographics    <- left_join(dataSetDemographics, read_excel(paste0(directoryPath, "AppendixSheet.xlsx"), sheet = "Country"), by = "Country")
dataSetDemographics    <- left_join(dataSetDemographics, read_excel(paste0(directoryPath, "AppendixSheet.xlsx"), sheet = "Language"), by = "Language")
dataSetDemographics    <- left_join(dataSetDemographics, read_excel(paste0(directoryPath, "AppendixSheet.xlsx"), sheet = "Application"), by = "ApplicationID")

#Data preparation - dataSetDemographics
#Convert datatype of column RegDate from character to Date
dataSetDemographics$RegDate <- as.Date(dataSetDemographics$RegDate)

#Convert datatype and format
dataSetDemographics$FirstPay <- as.Date(as.character(dataSetDemographics$FirstPay),format = "%Y%m%d")
dataSetDemographics$FirstAct <- as.Date(as.character(dataSetDemographics$FirstAct),format = "%Y%m%d")
dataSetDemographics$FirstSp <- as.Date(as.character(dataSetDemographics$FirstSp),format = "%Y%m%d")
dataSetDemographics$FirstCa <- as.Date(as.character(dataSetDemographics$FirstCa),format = "%Y%m%d")
dataSetDemographics$FirstGa <- as.Date(as.character(dataSetDemographics$FirstGa),format = "%Y%m%d")
dataSetDemographics$FirstPo <- as.Date(as.character(dataSetDemographics$FirstPo),format = "%Y%m%d")

#creating new gender label variable
dataSetDemographics <- dataSetDemographics %>%
  mutate(Gender_Label = if_else(dataSetDemographics$Gender == "0", "Female", "Male"))

#Replace missing gender values with "Not Specified"
dataSetDemographics$Gender[is.na(dataSetDemographics$Gender)] <- "Not Specified"

#Data preparation - dataSetUserAggregation
# Mutating the date format
dataSetUserAggregation <- dataSetUserAggregation %>%
  mutate(Date = as.Date(Date, format = "%Y%m%d"))

#Data preparation - dataSetPokerChip
#Convert column TransDateTime from chr to date
dataSetPokerChip$TransDateTime <- substr(dataSetPokerChip$TransDateTime, 1, 10)
dataSetPokerChip$TransDateTime <- as.Date(dataSetPokerChip$TransDateTime)

#creating new variable for buy and sell
dataSetPokerChip <- dataSetPokerChip %>%
  mutate(BuyOrSell = if_else(dataSetPokerChip$TransType == "124", "Buy", "Sell"))

#rounding TransAmount column
dataSetPokerChip$TransAmount <- round(dataSetPokerChip$TransAmount, digits = 3)


#Aggregate betting behavior data for bwin Internet sports subscribers who opened an account with bwin 
#during the period from February 1, 2005 through February 27, 2005.
#Filter for subscribers who opened accounts in the specified period
dataSetDemographics <- subset(dataSetDemographics, RegDate >= as.Date("2005-02-01") & RegDate <= as.Date("2005-02-27"))

#Participants who had no missing values for first active date and who registered during 
#the period of February 1, 2005 through February 27, 2005 should be entered into the data mart
#Filter the data based on criteria
dataSetDemographics <- dataSetDemographics %>%
  filter(!is.na(FirstAct) & RegDate >= as.Date("2005-02-01") & RegDate <= as.Date("2005-02-27"))


#Exclude records in the raw dataset UserDailyAggregation that took place before the first pay-in date
#Find the first pay-in date for each user
first_pay_dates <- dataSetDemographics %>%
  select(UserID, FirstPay)

# Filter the dataSetUserAggregation table to exclude records before the first pay-in date
dataSetUserAggregation <- dataSetUserAggregation %>%
  left_join(first_pay_dates, by = "UserID") %>%
  filter(Date >= FirstPay)

#first active date can be assigned as the earliest date of the first active date of all betting products.
# Find the first active date for non-poker products
first_non_poker_active_date <- dataSetUserAggregation %>%
  filter(ProductID != 3) %>%
  group_by(UserID) %>%
  summarize(FirstActiveDateNonPoker = min(Date))

# Find the first poker active date
first_poker_active_date <- dataSetPokerChip %>%
  group_by(UserID) %>%
  summarize(FirstPokerActiveDate = min(TransDateTime))

# Merge the results to get the earliest first active date
firstActiveDate <- full_join(first_non_poker_active_date, first_poker_active_date, by = "UserID")

# Create a new column with the earliest first active date
firstActiveDate <- firstActiveDate %>%
  mutate(FirstActiveDate = pmin(FirstActiveDateNonPoker, FirstPokerActiveDate, na.rm = TRUE))

#Selecting columns from UserAggregation for summarizing basetable based on customer per row
dataSetUserAggregationSelectCols <- dataSetUserAggregation %>%
  select(UserID, Stakes, Winnings, Bets)

# Group by UserID and calculate the sum of Stakes, Winnings, and Bets
dataMartUserAggregation <- dataSetUserAggregationSelectCols %>%
  group_by(UserID) %>%
  summarize(
    TotalStakes = sum(Stakes, na.rm = TRUE),
    TotalWinnings = sum(Winnings, na.rm = TRUE),
    TotalBets = sum(Bets, na.rm = TRUE)
  )

#Selecting columns from PokerChip for summarizing basetable based on customer per row
dataSetPokerChipSelectCols <- dataSetPokerChip %>%
  select(UserID, TransDateTime, TransType, TransAmount)

# Group by UserID and calculate the sums for Buy and Sell transactions
dataMartPokerChip <- dataSetPokerChipSelectCols %>%
  group_by(UserID) %>%
  summarize(
    TotalTransAmountBuy = sum(if_else(TransType == "124", TransAmount, 0)),
    TotalTransAmountSell = sum(if_else(TransType != "124", TransAmount, 0))
  )

# for dataset, user aggregation
productIDList <- dataSetUserAggregation %>%
  group_by(UserID) %>%
  summarize(
    ProductIDList = paste0(unique(ProductID), collapse = ", "),
    ProductDescList = paste0(unique(`Product Description`), collapse = ", ")
  )

# Find the last poker active date
lastActiveDate <- dataSetPokerChip %>%
  group_by(UserID) %>%
  summarize(LastActiveDate = max(TransDateTime))

#Join all dataset
marketingDataMart <- dataSetDemographics %>%
  #left_join(dataSetUserAggregation, by = "UserID") %>%
  left_join(dataMartUserAggregation, by = "UserID") %>%
  left_join(dataMartPokerChip, by = "UserID") %>%
  left_join(firstActiveDate, by = "UserID") %>%
  left_join(lastActiveDate, by = "UserID") %>%
  left_join(productIDList, by = "UserID") 

# Converting datetime to date
marketingDataMart <- marketingDataMart %>%
  mutate(
    RegDate = as.Date(RegDate),
    FirstPay = as.Date(FirstPay),
    FirstAct = as.Date(FirstAct),
    FirstSp = as.Date(FirstSp),
    FirstCa = as.Date(FirstCa),
    FirstGa = as.Date(FirstGa),
    FirstPo = as.Date(FirstPo),
    FirstActiveDateNonPoker = as.Date(FirstActiveDateNonPoker),
    FirstPokerActiveDate = as.Date(FirstPokerActiveDate),
    LastActiveDate = as.Date(LastActiveDate)
  )

# Fill empty values in LastActiveDate with '30/09/2005'
marketingDataMart$LastActiveDate[is.na(marketingDataMart$LastActiveDate)] <- as.Date("2005-09-30")

#Marketing metrics
#Customer Tenure
marketingDataMart <- marketingDataMart %>%
  mutate(CustomerTenure = as.numeric(LastActiveDate - RegDate))

# Frequency of Betting	
marketingDataMart <- marketingDataMart %>%
  mutate(FrequencyBetting = as.numeric(TotalBets / CustomerTenure))

# Frequency of Transactions	
NumberofBuyTrans <- dataSetPokerChip %>%
  filter(TransType == 124) %>%
  group_by(UserID) %>%
  summarize(NumberofBuyTrans = n())

marketingDataMart <- marketingDataMart %>%
  left_join(NumberofBuyTrans, by = "UserID")

# Store numberBets as an additional column
marketingDataMart$numberBets <- marketingDataMart$TotalBets

# Store customerTenure as an additional column
marketingDataMart$customerTenure <- marketingDataMart$CustomerTenure

marketingDataMart <- marketingDataMart %>%
  mutate(FrequencyTransactions = (NumberofBuyTrans / customerTenure))

#Transaction Type Ratio
NumberofSellTrans <- dataSetPokerChip %>%
  filter(TransType == 24) %>%
  group_by(UserID) %>%
  summarize(NumberofSellTrans = n())

marketingDataMart <- marketingDataMart %>%
  left_join(NumberofSellTrans, by = "UserID")

marketingDataMart <- marketingDataMart %>%
  mutate(TransactionTypeRatio = NumberofBuyTrans / NumberofSellTrans)

#Net Profit	
marketingDataMart <- marketingDataMart %>%
  mutate(NetProfit = as.numeric(TotalWinnings - TotalStakes))

#Win Rate based on Bets
marketingDataMart <- marketingDataMart %>%
  mutate(WinRateBets = (as.numeric(TotalWinnings / TotalBets)) * 100)

#Win Rate based on Stakes
marketingDataMart <- marketingDataMart %>%
  mutate(WinRateStakes = (as.numeric(TotalWinnings / TotalStakes)) * 100)

#Average Win based on Bets
marketingDataMart <- marketingDataMart %>%
  mutate(AvgWinBets = as.numeric(TotalWinnings / TotalBets))

#Average Win based on Stakes
marketingDataMart <- marketingDataMart %>%
  mutate(AvgWinStakes = as.numeric(TotalWinnings / TotalStakes))

#Return on Investment
marketingDataMart <- marketingDataMart %>%
  mutate(ROI = (as.numeric((TotalWinnings - TotalStakes) / TotalStakes)) * 100)

#Customer Lifetime Value
marketingDataMart <- marketingDataMart %>%
  mutate(CustomerLifetimeValue = as.numeric(TotalWinnings - TotalStakes))

#Average Sell Transaction Value per Customer 
marketingDataMart <- marketingDataMart %>%
  mutate(AverageSellTransValuePerCustomer = as.numeric(TotalTransAmountSell / NumberofSellTrans))

#Average Buy Transaction Value per Customer	
marketingDataMart <- marketingDataMart %>%
  mutate(AverageBuyTransValuePerCustomer	= as.numeric(TotalTransAmountBuy / NumberofBuyTrans))

#Customer Activity Score
marketingDataMart <- marketingDataMart %>%
  mutate(CustomerActivityScore	= (as.double(FrequencyBetting + FrequencyTransactions) / 2))

#Customer Value Score
#marketingDataMart <- marketingDataMart %>%
#  mutate(CustomerValueScore	= as.numeric((CustomerLifetimeValue+AverageTransValuePerCustomer+ROI)/3))

#Customer Engagement Score
marketingDataMart <- marketingDataMart %>%
  mutate(CustEngagementScore = as.numeric((numberBets/customerTenure)*100))

#Customer Engagement Index
marketingDataMart <- marketingDataMart %>%
  mutate(CustEngagementIndex = as.numeric((CustEngagementScore+FrequencyBetting+FrequencyTransactions)/3))

#Loyalty	(Total Number of Bets + Total Stakes) / Number of Days Since Last Transaction
marketingDataMart <- marketingDataMart %>%
  mutate(Loyalty = (TotalWinnings - TotalStakes) / (CustomerTenure * FrequencyBetting))

#Consumption
marketingDataMart <- marketingDataMart %>%
  mutate(Consumption = ((TotalWinnings - TotalStakes) + (TotalTransAmountSell - TotalTransAmountBuy)))

#Columns with negative that need imputation
neg_columns <- c("CustomerLifetimeValue", "Loyalty", "Consumption")

#Handle negative values
marketingDataMart <- marketingDataMart %>%
  mutate_at(vars(neg_columns), ~ifelse(. < 0, 0, .))

#Specify the columns for imputation with mean
mean_columns <- c(
  "FrequencyBetting",
  "TransactionTypeRatio",
  "NetProfit",
  "WinRateBets",
  "WinRateStakes",
  "AvgWinBets",
  "AvgWinStakes",
  "ROI",
  "CustomerLifetimeValue",
  "CustEngagementScore",
  "Loyalty"
)

#Impute null values with means
column_means <- marketingDataMart %>%
  summarise(across(all_of(mean_columns), ~mean(.[is.finite(.)], na.rm = TRUE)))

marketingDataMart <- marketingDataMart %>%
  mutate(across(all_of(mean_columns), ~ifelse(is.na(.) | !is.finite(.), column_means[[cur_column()]], .)))

#Specify the columns for imputation with 0
zero_columns <- c(
  "NumberofBuyTrans",
  "NumberofSellTrans",
  "TransactionTypeRatio",
  "AverageSellTransValuePerCustomer",
  "AverageBuyTransValuePerCustomer",
  "CustEngagementIndex",
  "CustomerActivityScore",
  "FrequencyTransactions",
  "Consumption"
)

#Impute null values with 0 
marketingDataMart <- marketingDataMart %>%
  mutate_at(vars(zero_columns), ~ifelse(is.na(.), 0, .))


#Convert 'ProductIDList' to a list of numbers
marketingDataMart$ProductIDList <- lapply(strsplit(as.character(marketingDataMart$ProductIDList), ",\\s*"), as.numeric)

#Create dummy variables for each Product ID
for(i in 1:8) {
  marketingDataMart[[paste0("ProductID_", i)]] <- sapply(marketingDataMart$ProductIDList, function(x) as.integer(i %in% x))
}

#Fill NAs in Gender_Label

marketingDataMart$Gender_Label <- ifelse(is.na(marketingDataMart$Gender_Label), "Male", marketingDataMart$Gender_Label)


#Renaming dummy columns
marketingDataMart <- marketingDataMart %>%
  rename(
    Product_Sports_book_fixed_odd = ProductID_1,
    Product_Sports_book_live_action = ProductID_2,
    Product_Poker_BossMedia = ProductID_3,
    Product_Casino_BossMedia = ProductID_4,
    Product_Supertoto = ProductID_5,
    Product_Games_VS = ProductID_6,
    Product_Games_bwin = ProductID_7,
    Product_Casino_Chartwell = ProductID_8
  )

#Dropping unnecessary columns
marketingDataMart <- marketingDataMart %>%
  select(-Country, -Language, -ApplicationID, -Gender, -TotalBets, -ProductIDList, -ProductDescList)



