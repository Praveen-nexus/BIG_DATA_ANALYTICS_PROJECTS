import streamlit as st
import yfinance as yf
import datetime
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import plotly.graph_objects as go
from datetime import datetime
from datetime import date
import plotly.express as px



#==============================================================================
# HOT FIX FOR YFINANCE .INFO METHOD
# Ref: https://github.com/ranaroussi/yfinance/issues/1729
#==============================================================================

import requests
import urllib

class YFinance:
    user_agent_key = "User-Agent"
    user_agent_value = ("Mozilla/5.0 (Windows NT 6.1; Win64; x64) "
                        "AppleWebKit/537.36 (KHTML, like Gecko) "
                        "Chrome/58.0.3029.110 Safari/537.36")
    
    def __init__(self, ticker):
        self.yahoo_ticker = ticker

    def __str__(self):
        return self.yahoo_ticker

    def _get_yahoo_cookie(self):
        cookie = None

        headers = {self.user_agent_key: self.user_agent_value}
        response = requests.get("https://fc.yahoo.com",
                                headers=headers,
                                allow_redirects=True)

        if not response.cookies:
            raise Exception("Failed to obtain Yahoo auth cookie.")

        cookie = list(response.cookies)[0]

        return cookie

    def _get_yahoo_crumb(self, cookie):
        crumb = None

        headers = {self.user_agent_key: self.user_agent_value}

        crumb_response = requests.get(
            "https://query1.finance.yahoo.com/v1/test/getcrumb",
            headers=headers,
            cookies={cookie.name: cookie.value},
            allow_redirects=True,
        )
        crumb = crumb_response.text

        if crumb is None:
            raise Exception("Failed to retrieve Yahoo crumb.")

        return crumb

    @property
    def info(self):
        # Yahoo modules doc informations :
        # https://cryptocointracker.com/yahoo-finance/yahoo-finance-api
        cookie = self._get_yahoo_cookie()
        crumb = self._get_yahoo_crumb(cookie)
        info = {}
        ret = {}

        headers = {self.user_agent_key: self.user_agent_value}

        yahoo_modules = ("assetProfile,"  # longBusinessSummary
                         "summaryDetail,"
                         "financialData,"
                         "indexTrend,"
                         "defaultKeyStatistics")

        url = ("https://query1.finance.yahoo.com/v10/finance/"
               f"quoteSummary/{self.yahoo_ticker}"
               f"?modules={urllib.parse.quote_plus(yahoo_modules)}"
               f"&ssl=true&crumb={urllib.parse.quote_plus(crumb)}")

        info_response = requests.get(url,
                                     headers=headers,
                                     cookies={cookie.name: cookie.value},
                                     allow_redirects=True)

        info = info_response.json()
        info = info['quoteSummary']['result'][0]

        for mainKeys in info.keys():
            for key in info[mainKeys].keys():
                if isinstance(info[mainKeys][key], dict):
                    try:
                        ret[key] = info[mainKeys][key]['raw']
                    except (KeyError, TypeError):
                        pass
                else:
                    ret[key] = info[mainKeys][key]

        return ret


# Create a Streamlit sidebar
st.sidebar.title("Stock Picker")
ticker_list = pd.read_html('https://en.wikipedia.org/wiki/List_of_S%26P_500_companies')[0]['Symbol']
global ticker  # Set this variable as global, so the functions in all of the tabs can read it
selected_stock = st.sidebar.selectbox("", ticker_list)
# Ticker auto-fill selection
# selected_stock = st.sidebar.text_input("Enter stock symbol (e.g., AAPL):")

if 'clicked' not in st.session_state:
    st.session_state.clicked = False

def click_button():
    st.session_state.clicked = True

# Get the company information
@st.cache_data
def GetCompanyInfo(ticker):
    """
    This function get the company information from Yahoo Finance.
    """        
    return YFinance(ticker).info
    #return yf.Ticker(ticker).info

def fetch_stock_dataSummary(selected_stock, selected_duration):
    try:
        stock = yf.Ticker(selected_stock)
        #stock_data = stock.history(start=start_date, end=end_date, period=selected_duration)
        stock_data = stock.history(period=selected_duration)
        return stock_data
    except Exception as e:
        st.error(f"Error fetching stock data: {e}")
        return None

# Function to fetch stock data
def fetch_stock_dataChart(selected_stock, start_date, end_date, selected_duration):
    try:
        stock = yf.Ticker(selected_stock)
        #stock_data = stock.history(start=start_date, end=end_date, period=selected_duration)
        stock_data = stock.history(period=selected_duration)
        return stock_data
    except Exception as e:
        st.error(f"Error fetching stock data: {e}")
        return None

# Function to create an area chart
def create_area_chart(stock_data):
    fig = go.Figure(data=[go.Scatter(x=stock_data.index, y=stock_data['Close'], fill='tozeroy', line=dict(color='blue'), name='Stock Price')])
    fig.update_layout(title=f"Stock Price Area Chart for {selected_stock}")
    return fig

# Function to create a line plot
def create_line_plot(stock_data, selected_duration, selected_interval, selected_stock):
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=stock_data.index, y=stock_data['Close'], mode='lines', name='Stock Price'))
    fig.update_layout(
        title=f"Stock Price Line Chart for {selected_stock} - {selected_interval} Interval",
        xaxis_rangeslider_visible=False,
        xaxis=dict(
            rangeslider=dict(visible=False),
            type='date',
            rangebreaks=[dict(enabled=True)]
        ),
        xaxis_title="Date",
        yaxis_title="Price",
        showlegend=True
    )
    fig.update_xaxes(type="date")
    fig.update_yaxes(automargin=True)
    return fig


# Function to create a candlestick plot
def create_candlestick_plot(stock_data, selected_duration, selected_interval, selected_stock):
    fig = go.Figure(data=[go.Candlestick(x=stock_data.index,
        open=stock_data['Open'],
        high=stock_data['High'],
        low=stock_data['Low'],
        close=stock_data['Close'], name='Stock Price')])
    fig.update_layout(title=f"Stock Price for {selected_stock}",
                      xaxis_rangeslider_visible=False,
                      xaxis=dict(rangeslider=dict(visible=False),
                                 type='date',
                                 rangebreaks=[dict(enabled=True)]
                                ),
                      xaxis_title="Date",
                      yaxis_title="Price",
                      showlegend=True
                     )
    fig.update_xaxes(type="date")
    fig.update_yaxes(automargin=True)
    return fig
#==============================================================================
# Tab Summary
#==============================================================================
def renderSummaryTab():
    # Radio button group for duration selection at the top of the chart
    selected_durationSummary = st.radio(
        "Select Chart Duration",
        ["1MO", "3MO", "6MO", "YTD", "1Y", "3Y", "5Y", "MAX"],
        key="visibility",
        horizontal=True
    )

    if selected_stock:
        #stock_data = fetch_stock_data(selected_stock, start_date, end_date, selected_duration)
        stock_data = fetch_stock_dataSummary(selected_stock, selected_durationSummary)
        if stock_data is not None and not stock_data.empty:

            # Create and display the area chart
            area_chart = create_area_chart(stock_data)
            st.plotly_chart(area_chart)

            # Create checkboxes to control data display
            show_stock_dataSummary = st.checkbox("Show Stock Data", key='visibilityCheckboxSummary')

            if show_stock_dataSummary:
                st.subheader(f"Stock Data for {selected_stock}")
                st.write(stock_data)

        else:
            st.warning("No data available for the given symbol or date range.")

#==============================================================================
# Tab Chart
#==============================================================================
def renderChartTab():
    # Time interval selection
    selected_interval = st.radio(
        "Select Time Interval",
        ["1D", "5D", "1WK", "1MO", "3MO"],
        key="visibilityIntervalChart",
        index=2,  # Set default to 1 week
        horizontal=True
    )

    # Radio button group for duration selection at the top of the chart
    selected_durationChart = st.radio(
        "Select Chart Duration",
        ["1MO", "3MO", "6MO", "YTD", "1Y", "3Y", "5Y", "MAX"],
        key="visibilityDurationChart",
        horizontal=True
    )
        
    if selected_stock:
        stock_data = fetch_stock_dataChart(selected_stock, start_date, end_date, selected_durationChart)
        #stock_data = fetch_stock_data(selected_stock, selected_durationChart)
        if stock_data is not None and not stock_data.empty:
            # Create and display the selected plot type
            if plot_type == "Line Plot":
                stock_chart = create_line_plot(stock_data, selected_durationChart, selected_interval, selected_stock)
            else:
                stock_chart = create_candlestick_plot(stock_data, selected_durationChart, selected_interval, selected_stock)

            st.plotly_chart(stock_chart)

            # Create checkboxes to control data display
            show_stock_data = st.checkbox("Show Stock Data", key='visibilityCheckboxChart')


            if show_stock_data:
                st.subheader(f"Stock Data for {selected_stock}")
                st.write(stock_data)
        else:
            st.warning("No data available for the given symbol or date range.")
#==============================================================================
# Tab Monte Carlo Simulation
#==============================================================================
# Function to perform Monte Carlo simulation and estimate VaR
def monte_carlo_simulation(stock_data, n_simulations, time_horizon):
    returns = stock_data['Close'].pct_change().dropna()
    mean_return = returns.mean()
    volatility = returns.std()

    simulation_results = []

    for _ in range(n_simulations):
        daily_returns = np.random.normal(mean_return, volatility, time_horizon)
        price_simulation = stock_data['Close'].iloc[-1] * (1 + daily_returns).cumprod()
        simulation_results.append(price_simulation)

    simulation_results = np.array(simulation_results)
    return simulation_results

# Function to estimate VaR
def estimate_var(simulation_results):
    var_95 = np.percentile(simulation_results, 5)
    return var_95

#==============================================================================
# Main app content
#==============================================================================



st.title("Trade Insights Hub")

tab1, tab2, tab3, tab4, tab5 = st.tabs(["Summary", "Chart", "Financials", "Monte Carlo simulation", "Dividends"])

with tab1:
    st.subheader("Company profile")

    # st.write(GetCompanyInfo(selected_stock))
    companyProfile = GetCompanyInfo(selected_stock)

    try:
        state = companyProfile['state']
    except KeyError:
        state = ''


    col1, col2 = st.columns([1, 1])
    with col1:
        st.write(f"{companyProfile['address1']}")
        st.write(f"{companyProfile['city']}, {state} {companyProfile['zip']}")
        st.write(f"{companyProfile['country']}")
        st.write(f"{companyProfile['phone']}")
        st.write(f"{companyProfile['website']}")

    with col2:
        st.markdown(f"Sector(s): **{companyProfile['sector']}**")
        st.markdown(f"Industry: **{companyProfile['industry']}**")
        st.markdown(f"Full Time Employees: **{companyProfile['fullTimeEmployees']}**")

    companyProfile = GetCompanyInfo(selected_stock)


    # Access the 'fmt' value inside the 'totalPay' column
    def get_fmt(total_pay):
        if isinstance(total_pay, dict):
            return total_pay.get('fmt', None)
        return None

    officeDf = pd.DataFrame(companyProfile['companyOfficers'])

    officeDf['totalPay_fmt'] = officeDf['totalPay'].apply(get_fmt)
    officeDf['exercisedValue_fmt'] = officeDf['exercisedValue'].apply(get_fmt)

    newTwo = pd.DataFrame(officeDf.loc[:, ['name', 'title', 'totalPay_fmt', 'exercisedValue_fmt', 'yearBorn']])
    newDf = newTwo.rename(columns={'name': 'Name', 'title': 'Title', 'totalPay_fmt': 'Pay', 'exercisedValue_fmt': 'Exercised', 'yearBorn': 'Year Born'}, inplace = True)

    
    st.subheader("Key Executives")
    st.dataframe(newTwo, hide_index=True, use_container_width=True)

    st.subheader("Company description")
    # Show to stock image
    col1, col2, col3 = st.columns([1, 3, 1])

    
    
    # If the ticker is already selected
    if selected_stock != '':
        # Get the company information in list format
        info = GetCompanyInfo(selected_stock)
        
        # Show the company description using markdown + HTML
        st.markdown('<div style="text-align: justify;">' + \
                    info['longBusinessSummary'] + \
                    '</div><br>',
                    unsafe_allow_html=True)    

    st.subheader("Major shareholders")
   # Get major shareholders data for selected stock
    # major_holders = yf.Ticker(selected_stock).major_holders

    # Display major shareholders as DataFrame without index
    # styler = major_holders.style.set_table_styles([{'selector': 'thead', 'props': 'display: none;'}])
    # st.write(styler.hide_index().render(), unsafe_allow_html=True)
    # st.write(major_holders)


    # Rename headers if needed
    # major_holders = major_holders.rename(columns={"some_old_column_name": "new_column_name"})

    # Display major holders as a table
    # st.table(major_holders, header=None)
# Get major holders data for selected stock
    major_holders_data = yf.Ticker(selected_stock).major_holders

    df_metadata = pd.DataFrame({
        "% of share holders": [major_holders_data[0][0], major_holders_data[0][1], major_holders_data[0][2], major_holders_data[0][3]],
        "share holders": [major_holders_data[1][0], major_holders_data[1][1], major_holders_data[1][2], major_holders_data[1][3]]
    })

    st.dataframe(df_metadata, hide_index=True, use_container_width=True)

    renderSummaryTab()


with tab2:

    # Create two columns for date inputs
    start_date, end_date = st.columns([1, 1]) 
    with start_date:
        # Set default start date
        default_start_date = date(2022, 1, 1)

        # Create date input with default start date
        start_date = st.date_input("Start Date", default_start_date)
        # start_date = st.date_input("Start Date", datetime.date(2022, 1, 1))
    with end_date:
        # end_date = st.date_input("End Date", datetime.date.today())
        # Set default end date
        default_end_date = date.today()

        # Create date input with default end date
        end_date = st.date_input("End Date", default_end_date)

    # Create a radio button for selecting the plot type
    plot_type = st.radio("Select Chart Type", ["Line Plot", "Candlestick Plot"], 
        key="visibilityChart", 
        horizontal=True)

    renderChartTab()

    
with tab3:
    radioPeriod = st.radio("", ["Annual", "Quarterly period"], key="visibilityradioPeriod", horizontal=True)
    Income, Balance, Cash = st.tabs(["Income Statement", "Balance Sheet", "Cash Flow"])

    with Income:
        if radioPeriod == "Annual":
            # Fetch income statement data
            income_statement = yf.Ticker(selected_stock).income_stmt
            
            # Display the income statement data using Streamlit
            st.title("Income Statement")
            st.write(income_statement)
        else:
            # Fetch income statement data
            quarterly_income_stmt = yf.Ticker(selected_stock).quarterly_income_stmt

            # Display the income statement data using Streamlit
            st.title("Income Statement")
            st.write(quarterly_income_stmt)

    with Balance:
        if radioPeriod == "Annual":
            # Fetch income statement data
            balance_sheet = yf.Ticker(selected_stock).balance_sheet

            # Display the income statement data using Streamlit
            st.title("Balance Sheet")
            st.write(balance_sheet)
        else:
            # Fetch income statement data
            quarterly_balance_sheet = yf.Ticker(selected_stock).quarterly_balance_sheet

            # Display the income statement data using Streamlit
            st.title("Balance Sheet")
            st.write(quarterly_balance_sheet)
    with Cash:
        if radioPeriod == "Annual":
            # Fetch income statement data
            cashflow = yf.Ticker(selected_stock).cashflow

            # Display the income statement data using Streamlit
            st.title("Cash Flow")
            st.write(cashflow)
        else:
            # Fetch income statement data
            quarterly_cashflow = yf.Ticker(selected_stock).quarterly_cashflow

            # Display the income statement data using Streamlit
            st.title("Cash Flow")
            st.write(quarterly_cashflow)
with tab4:
    # Fetch historical data for AAPL
    stock_data = yf.Ticker(selected_stock).history(period="1y")

    col1, col2 = st.columns(2)
   
    with col1:
         # Dropdown for the number of simulations
         n_simulations = st.selectbox("Number of Simulations", [200, 500, 1000])

    with col2:
        # Dropdown for the time horizon
        time_horizon = st.selectbox("Time Horizon (Days)", [30, 60, 90])

    # Run the Monte Carlo simulation
    simulation_results = monte_carlo_simulation(stock_data, n_simulations, time_horizon)

    # Plot the simulation results
    st.subheader(f"Monte Carlo Simulation Result for Stock Closing Price for {selected_stock}")
    plt.figure(figsize=(10, 6))
    plt.plot(simulation_results.T)
    plt.title("Monte Carlo Simulation for Stock Closing Price")
    plt.xlabel("Time Horizon (Days)")
    plt.ylabel("Stock Price")
    st.pyplot(plt)

    # Estimate and present VaR
    var_95 = estimate_var(simulation_results)
    st.text(f"Value at Risk (VaR) at 95% Confidence Interval: ${var_95:.2f}")

    # Display the original stock data
    st.subheader("Original Stock Data")
    st.write(stock_data)

with tab5:
    # Get dividends data for AAPL
    ticker = yf.Ticker("AAPL")
    dividends = ticker.dividends.reset_index()

    # Create a line chart
    fig = px.line(dividends, x='Date', y='Dividends', title='AAPL Dividends Over Time')
    st.plotly_chart(fig)


    # Get historical metadata for AAPL
    varTicker = yf.Ticker('AAPL').history_metadata

    df_metadata = pd.DataFrame({
        "Metadata": ["Symbol", "Currency", "Exchange Name", "Instrument Type", "Exchange Time zone Name", "First Trade Date", "Regular Market Time", "Regular Market Price", "Chart Previous Close", "Previous Close"],
        "Value": [varTicker.get("symbol"), varTicker.get("currency"), varTicker.get("exchangeName"), varTicker.get("instrumentType"), varTicker.get("exchangeTimezoneName"), datetime.utcfromtimestamp(varTicker.get("firstTradeDate")), datetime.utcfromtimestamp(varTicker.get("regularMarketTime")), varTicker.get("regularMarketPrice"), varTicker.get("chartPreviousClose"), varTicker.get("previousClose")]
    })

    st.dataframe(df_metadata, hide_index=True, use_container_width=True)