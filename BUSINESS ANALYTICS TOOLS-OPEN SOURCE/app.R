library(dplyr)
library(shiny)
library(DT)
library(ggplot2)
library(reshape2)
library(lubridate)
library(readxl)
library(plotly)

# Load your marketingDataMart dataset
marketingDataMartShiny <- read_excel("C:/_BigDataCourses/0604 OpenSourceProgramming_R/GroupProject/FinalTerm_Work/ShinyApp/marketingDataMart_Final.xlsx")


# Extracting month from Date columns
marketingDataMartShiny$RegMonth <- month(marketingDataMartShiny$RegDate)
marketingDataMartShiny$FirstPayMonth <- month(marketingDataMartShiny$FirstPay)
 
# Define a function to categorize FrequencyBetting into groups
categorizeFrequencyBetting <- function(x) {
  ifelse(x < 2.47, "Below Average", ifelse(x > 2.47, "Above Average", "Average"))
}
 
# Categorize FrequencyBetting into groups
marketingDataMartShiny$FreqBetGroups <- categorizeFrequencyBetting(marketingDataMartShiny$FrequencyBetting)
 

# Define UI for the Shiny app
ui <- fluidPage(
  titlePanel("Marketing Data Exploration"),
  mainPanel(
    tabsetPanel(
      # Tab 1: General
      tabPanel("General",

       
                plotlyOutput("userCountWorldMap"),
               plotOutput("genderOfUsersCount"),
                plotlyOutput("plotAvgWinBets"),
               plotlyOutput("plotAvgWinStakes"),
              plotlyOutput("Customer_Activity_Score_Application_Description"),
              plotlyOutput("AverageBuySell_FirstActive_lineChart")
      ),
      # Tab 2: Gender
      
      tabPanel("Gender",
          sidebarLayout(
              sidebarPanel(
                selectInput("gender", "Select Gender",
                            choices = c("All", "Male", "Female"),
                            selected = "All")
              ),
              mainPanel(
                plotlyOutput("plot2"),
                plotlyOutput("plot3"),
                plotlyOutput("plot4"),
                plotlyOutput("freqBetGroupsPlot")
              )
            )
      ),
      
      
      # Tab 3: Country
      
      tabPanel("Country",
          plotlyOutput("CustomerTenure_barPlot"),
          plotlyOutput("AverageFrequencyBetting_country_BarPlot"),
          plotlyOutput("countryAppCountsStackedBarPlot")
          
          
      )
    )
  )
)


# Define server logic
server <- function(input, output) {
# Create stacked bar chart of bet distribution

  # Tab 1: General
# Create a subset to count Users and each gender per country
  country_data <- marketingDataMartShiny %>%
    group_by(Country_Name) %>%
    summarise(
      TotalUserCount = n(),
      MaleCount = sum(Gender_Label == "Male", na.rm = TRUE),
      FemaleCount = sum(Gender_Label == "Female", na.rm = TRUE),
      LanguageDescriptions = toString(unique(Language_Description))
    )
# Generate the world map using plotlyOutput() and renderPlotly()
  output$userCountWorldMap <- renderPlotly({


    plot_ly(
      data = country_data,
      type = "choropleth",
      locations = ~`Country_Name`,
      z = ~TotalUserCount,
      locationmode = "country names",
      colorscale = "Viridis",
      text = ~paste("Country: ", `Country_Name`,
                    "<br>Total Users: ", TotalUserCount,
                    "<br>Male Users: ", MaleCount,
                    "<br>Female Users: ", FemaleCount,
                    "<br>Language(s): ", LanguageDescriptions)
      ) %>%
      layout(
        title = "User Count by Country",
        geo = list(
          showframe = FALSE,
          projection = list(type = "mercator")
        ),
        width = 1200
      ) 
  })

  output$genderOfUsersCount <- renderPlot({
    # Count users for each gender
    gender_counts <- marketingDataMartShiny %>%
      group_by(Gender_Label) %>%
      summarise(UserCount = n())

    # Create a bar plot of Gender Distribution
    ggplot(gender_counts, aes(x = Gender_Label, y = UserCount, fill = Gender_Label)) +
      geom_bar(stat = "identity") +
      labs(title = "Gender Distribution",
           x = "Gender",
           y = "Number of Users") +
      theme_minimal()
  })
  
   
  output$plotAvgWinBets <- renderPlotly({
    p <- plot_ly(marketingDataMartShiny, x = ~Application_Description, y = ~AvgWinBets, type = 'bar', color = ~Application_Description) %>%
      layout(title = "AvgWinBets based on Application Description",
             xaxis = list(title = "Application Description"),
             yaxis = list(title = "AvgWinBets"))
    p
  })
  output$plotAvgWinStakes <- renderPlotly({
    p <- plot_ly(marketingDataMartShiny, x = ~Application_Description, y = ~AvgWinStakes, type = 'bar', color = ~Application_Description) %>%
      layout(title = "AvgWinStakes based on Application Description",
             xaxis = list(title = "Application Description"),
             yaxis = list(title = "AvgWinStakes"))
    p
  })
  
  #Scatter plot of Customer Activity Score and Application Description
  output$Customer_Activity_Score_Application_Description <- renderPlotly({
    plot_ly(data = marketingDataMartShiny, x = ~CustomerActivityScore, y = ~Application_Description, type = "scatter", mode = "markers") %>%
      layout(title = "Customer Activity Score vs. Application Description",
             xaxis = list(title = "Customer Activity Score"),
             yaxis = list(title = ""))
  })

  
  #Set the minimum and maximum values for the y-axis
  min_value <- 0
  max_value <- 1000
  
  # Line chart of Average Buy and Sell Transaction Value per Customer vs. First Active Date
  output$AverageBuySell_FirstActive_lineChart <- renderPlotly({
    plot_ly(data = marketingDataMartShiny, x = ~FirstActiveDate) %>%
      add_trace(y = ~AverageBuyTransValuePerCustomer, name = "Average Buy Transaction Value per Customer", type = "scatter", mode = "markers") %>%
      add_trace(y = ~AverageSellTransValuePerCustomer, name = "Average Sell Transaction Value per Customer", type = "scatter", mode = "markers") %>%
      layout(
        title = "Average Buy and Sell Transaction Value per Customer vs. First Active Date",
        xaxis = list(tickformat = "%Y-%m-%d"),
        yaxis = list(title = "Average Transaction Value per Customer", range = c(min_value, max_value))
      )
  })

  
 # Tab 2: Gender
 

  filteredDataGender <- reactive({
    data <- marketingDataMartShiny
    if (input$gender != "All") {
      data <- data[data$Gender_Label == input$gender, ]
    }
    return(data)
  })
  
  output$freqBetGroupsPlot <- renderPlotly({
    data <- filteredDataGender()
    freq_bet_counts <- count(data, FreqBetGroups)
    plot_ly(freq_bet_counts, x = ~FreqBetGroups, y = ~n, type = 'bar') %>%
      layout(title = "FrequencyBetting Groups Count",
             xaxis = list(title = "FrequencyBetting Groups"),
             yaxis = list(title = "Count"))
  })
  output$plot2 <- renderPlotly({
    data <- filteredDataGender()
    count_data <- count(data, FirstPayMonth)
    plot_ly(count_data, x = ~factor(FirstPayMonth), y = ~n, type = 'bar') %>%
      layout(title = "Count of FirstPay based on Months",
             xaxis = list(title = "Months"),
             yaxis = list(title = "Count"))
  })
  output$plot3 <- renderPlotly({
    data <- filteredDataGender()
    count_data <- count(data, CustomerTenure)
    plot_ly(count_data, x = ~factor(CustomerTenure), y = ~n, type = 'bar') %>%
      layout(title = "Count of CustomerTenure",
             xaxis = list(title = "CustomerTenure"),
             yaxis = list(title = "Count"))
  })
  output$plot4 <- renderPlotly({
    data <- filteredDataGender()
    count_data <- count(data, numberBets)
    plot_ly(count_data, x = ~factor(numberBets), y = ~n, type = 'bar') %>%
      layout(title = "Count of numberBets",
             xaxis = list(title = "numberBets"),
             yaxis = list(title = "Count"))
  })


# Tab 3: Country

  # Filter the data to include only the top 10 countries
  top_10_countries <- marketingDataMartShiny %>%
    group_by(Country_Name) %>%
    summarise(TotalCustomerTenure = sum(CustomerTenure)) %>%
    arrange(desc(TotalCustomerTenure)) %>%
    top_n(10)

  # Filter the data to include only the top 10 countries
  output$CustomerTenure_barPlot <- renderPlotly({
    top_10_countries <- marketingDataMartShiny %>%
      group_by(Country_Name) %>%
      summarise(TotalCustomerTenure = sum(CustomerTenure)) %>%
      arrange(desc(TotalCustomerTenure)) %>%
      top_n(10)
    plot_ly(data = top_10_countries, x = ~Country_Name, y = ~TotalCustomerTenure, type = "bar") %>%
      layout(
        title = "Total Customer Tenure for Top 10 Countries",
        xaxis = list(title = "Country Name"),
        yaxis = list(title = "Total Customer Tenure"),
        hovermode = "closest"
      )
  })

  # Filter the data to include only the top 10 countries
  top_10_countries_AvgFreq <- marketingDataMartShiny %>%
    group_by(Country_Name) %>%
    summarise(AverageFrequencyBetting = mean(FrequencyBetting, na.rm = TRUE)) %>%
    arrange(desc(AverageFrequencyBetting)) %>%
    top_n(10)

  # Generate the bar plot using plotlyOutput() and renderPlotly()
  output$AverageFrequencyBetting_country_BarPlot <- renderPlotly({
    plot_ly(data = top_10_countries_AvgFreq, x = ~Country_Name, y = ~AverageFrequencyBetting, type = "bar") %>%
      layout(
        title = "Average Frequency Betting for Top 10 Countries",
        xaxis = list(title = "Country Name"),
        yaxis = list(title = "Average Frequency Betting"),
        hovermode = "closest"
      )
  })

  # Filter the data to include only the top 10 countries
  top_10_countriesTotalApp <- marketingDataMartShiny %>%
    group_by(Country_Name) %>%
    summarise(TotalApplications = n()) %>%
    arrange(desc(TotalApplications)) %>%
    top_n(10)

  # Create the summary table for count of Application Descriptions per country
  country_app_counts <- marketingDataMartShiny %>%
    filter(Country_Name %in% top_10_countriesTotalApp$Country_Name) %>%
    group_by(Country_Name, Application_Description) %>%
    summarise(CountApplications = n()) %>%
    arrange(Country_Name, desc(CountApplications))

  # Generate the stacked bar plot using plotlyOutput() and renderPlotly()
  output$countryAppCountsStackedBarPlot <- renderPlotly({
    plot_ly(data = country_app_counts, x = ~Country_Name, y = ~CountApplications, type = "bar",
            color = ~Application_Description) %>%
      layout(
        title = "Stacked Bar Plot of Application Descriptions for Top 10 Countries",
        xaxis = list(title = "Country Name"),
        yaxis = list(title = "Count of Application Descriptions"),
        barmode = "stack",
        hovermode = "closest"
      )
  })
}

# Run the application
shinyApp(ui = ui, server = server)