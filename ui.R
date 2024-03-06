library(shiny)
library(bslib)
library(plotly)

df <- read.csv("cleaned_df.csv")
## OVERVIEW TAB INFO

# Manually Determine a BootSwatch Theme
my_theme <- bs_theme(bg = "#f5c77e", #background color
                     fg = "#883000", #foreground color
                     primary = "white", # primary color
) 


overview_tab <- tabPanel("Introduction",
                h1("Correlation between Honey Production and Climate Change"),
                p("Our research endeavors to unravel the potential correlations between climate change and honey production in the United States from 2000 to 2012. We present the data through three distinctive graphs, including, average temperature trends, the number of bee colonies in each state, and the number of honey production across various states."),
                h3("Major Questions:"),
                p("What influence does climate change exert on honey production? How do fluctuations in average temperatures and bee colony numbers correlate with variations in honey production and pricing?"),
                h3("Data Sources:"),
                p("The data utilized in this study is sourced from https://www.kaggle.com/datasets/jessicali9530/honey-production and https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data?select=GlobalLandTemperaturesByCountry.csv. The first dataset provides information on honey production from 1998 to 2012. The second dataset provides global climate change in average temperature from 1743 to 2013. For comparison, we have combined the two datasets and matched dates for better visualization"),
                p("Ethical Considerations and Limitations: While conducting our analysis, we remain mindful of potential ethical questions associated with data usage. The limitations of the dataset may include incomplete or unavailable information for certain states. We encourage a thoughtful consideration of these aspects in the interpretation of our findings."),
                img(src = "https://www.honeysource.com/wp-content/uploads/2023/02/HoneySourceByGlorybee-217412-Largest-Honey-Countries-Blogbanner1.jpg", alt = "Visual Representation"),
   
)

## VIZ 1 TAB INFO

viz_1_sidebar <- sidebarPanel(
  h2("Exploring Climate Changes"),
  sliderInput(inputId = "user_selection",
              label = "choose the year range",
              max = 2012,
              min = 2000,
              value = c(2000, 2005)
  ),
  h3("Description"),
  p("This graph appears to display a trend in average temperature over a span of 
    years, from 2000 to approximately 2012. 
    the average temperature fluctuates over the years. It starts at a point just 
    below 12 celsius around the year 2000, decreases slightly, rises until around 
    2002, then drops sharply reaching its lowest point at around 2005. After that, 
    it rises significantly until around 2007, has a brief dip and then a sharp 
    increase from about 2008 to the end of the dataset.
    The trend, particularly from 2008 onwards, suggests a significant increase 
    in average temperature, which could be indicative of warming. ")
  
  #TODO: Put inputs for modifying graph here
)

viz_1_main_panel <- mainPanel(
  h2("Average Climate Changes Over Years"),
  plotlyOutput(outputId = "avg_temp_plot")
)

viz_1_tab <- tabPanel("Climate Trends",
                      sidebarLayout(
                        viz_1_sidebar,
                        viz_1_main_panel
                      )
)
## VIZ 2 TAB INFO

viz_2_sidebar <- sidebarPanel(
  h2("Exploring change in bee colonies"),
  # TODO: Put inputs for modifying graph here
  sliderInput("year", "Select Year:", 
              min = min(df$year_numeric), 
              max = max(df$year_numeric),
              value = 2012,
              step = 1),
  h3("Description"),
  p("This graph is a visualization of the number of bee colonies in each states 
    in the US from year 2000 to 2012. *Please note that these states are removed 
    due to their NA values in the dataset: Alaska, Nevada, Maryland, Delaware, 
    Georgia, South Carolina, Rhode Island, New Hampshire, Connecticut, Massachusetts.  
    The changes are very gradual, due to the fact that certain states maintained 
    fairly even number of bee colonies. ")
)

viz_2_main_panel <- mainPanel(
  h2("Bee Colonies Over Time"),  # Update title
  plotlyOutput(outputId = "numcol_overtime")  # Use the output ID from server.R
)

viz_2_tab <- tabPanel("Bee Colonies Visualization",
                      sidebarLayout(
                        viz_2_sidebar,
                        viz_2_main_panel
                      )
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  h2("Comparing total honey production with price per pound"),
  #TODO: Put inputs for modifying graph here
  
  selectInput(
    inputId = "user_selection_state",
    label = "choose the state",
    choices = df$state
    ),
  sliderInput(inputId = "user_selection_year",
              label = "choose the year range",
              max = 2012,
              min = 2000,
              value = c(2000, 2012)
  ),
  h3("Description"),
  p("Depending on differnt states, honey production and honey price showcase different 
    kinds of realtionships. North Dakota which is top honey production state in 
    the US shows that when price of honey increased, honey production almost kept the same.")
)

viz_3_main_panel <- mainPanel(
  h2("Comparison between production and price"),
  plotlyOutput(outputId = "production_plot")
  
)

viz_3_tab <- tabPanel("Honey Production Visualization",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("What’s the result?"),
 p("In conclusion, the provided graphs suggest a significant correlation between climate change and honey production in the United States from 2000 to 2012. The average temperature changes along with the gradual changes in the number of bee colonies, highlight the sensitivity of honey production to environmental shifts. These findings emphasize the urgent need for further research and proactive measures to mitigate the adverse effects of climate change on the crucial honeybee industry, as it becomes increasingly clear that environmental shifts have a substantial and adverse influence on honey production."),
 p("Our comprehensive analysis covering the period from 2000 to 2012 has produced strong evidence of a significant relationship between changes in climate and the complex dynamics of honey production in the United States. Interestingly, the noticeable increase in mean temperatures starting in 2008 coincides with a notable decline in honey production, highlighting the industry's vulnerability to the growing effects of climate change."),
 p("Moreover, the slow but steady variations in the number of bee colonies found in different states provide insight into the complex interactions between bee populations and the results of honey production. Honey output is more steady in locations where colony numbers remain stable, while honey yields are greater in areas where bee populations change.  This complex relationship highlights how beekeeping techniques are interrelated and have an impact on honey output."),
 p("The project also reveals a significant change in the honey consumption environment, with a growing reliance on imported honey. The reduction in the capacity for local production, in addition to a greater reliance on foreign suppliers, is an alarming indicator of the ongoing challenges that the American honey sector faces. This change can be seen by the effects of earlier problems, including Colony Collapse Disorder, which highlights the necessity of implementing resilient and sustainable beekeeping techniques.")
)

## Overall UI Navbar

ui <- navbarPage(
  theme = my_theme,
  "Climate change and Honey production in the US",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)