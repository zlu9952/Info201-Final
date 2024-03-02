library(shiny)
library(bslib)

df <- read.csv("cleaned_df.csv")
## OVERVIEW TAB INFO

# Manually Determine a BootSwatch Theme
my_theme <- bs_theme(bg = "#f5c77e", #background color
                     fg = "#883000", #foreground color
                     primary = "white", # primary color
) 
# Update BootSwatch Theme
#my_theme <- bs_theme_update(my_theme, bootswatch = "sketchy") 

overview_tab <- tabPanel("Introduction",
   h1("Some title"),
   p("some explanation")
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
              value = min(df$year_numeric),
              step = 1),
  h3("Description"),
  p("This graph is a visualization of the number of bee colonies in each states in the US from year 2000 to 2012. *Please note that these states are removed due to their NA values in the dataset: Alaska, Nevada, Maryland, Delaware, Georgia, South Carolina, Rhode Island, New Hampshire, Connecticut, Massachusetts.  The changes are very gradual, due to the fact that certain states maintained fairly even number of bee colonies. ")
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
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_3_main_panel <- mainPanel(
  h2("Vizualization 3 Title"),
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_3_tab <- tabPanel("Viz 3 tab title",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion Tab Title",
 h1("Some title"),
 p("some conclusions")
)

## Overall UI Navbar

ui <- navbarPage(
  theme = my_theme,
  "Example Project Title",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)