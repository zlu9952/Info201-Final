library(shiny)
library(plotly)
library(ggplot2)
library(tidyverse)
library(usmap)

# Read the data
df <- read.csv("cleaned_df.csv")
state_name_abv_df <- data.frame(State.Code = state.abb, State.Name = state.name)
coord <- read.csv("US_GeoCode.csv")

# Define server logic
server <- function(input, output) {
  
  output$avg_temp_plot <- renderPlotly({ 
    
    select_df <- subset(df,year_numeric >= input$user_selection[1] & year_numeric <= input$user_selection[2])
    
    
    avg_temp_plot <- ggplot(data = select_df)+
      geom_line(mapping = aes(
        x = year_numeric,
        y = avg_temp)) +
      labs(
        x = "Year",
        y = "Average temperature in celsius"
      )
    
    
    return(ggplotly(avg_temp_plot))
  })
  
  # Reactive function to filter data based on selected year
  selected_year_data <- reactive({
    df[df$year_numeric == input$year, ]
  })
  
  # Merge data with state abbreviation dataframe
  merged_df <- reactive({
    left_join(selected_year_data(), state_name_abv_df, by = c("state" = "State.Code"))
  })
  
  # Merge with coordinates data
  final_df <- reactive({
    left_join(merged_df(), coord, by = c("State.Name" = "state.teritory"))
  })
  
  # Render plot
  output$numcol_overtime <- renderPlotly({
    p <- plot_usmap(data = final_df(), values = "numcol", include = c("AL","AR","AZ","CA","CO","FL","HI","IA","ID","IL","IN","KS","KY","LA","ME","MI","MN","MO","MS","MT","NC","ND","NE","NJ","NM","NY","OH","OR","PA","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY"), color = "azure3") + 
      scale_fill_continuous(breaks = c(2000, 8000, 100000, 250000, 400000, 500000),
                            labels = scales::comma(c(2000, 8000, 100000, 250000, 400000, 500000)),
                            low = "white", high = "orange", name = "Number of Colonies")  +
      labs(title = paste("Bee Colonies in", input$year)) +
      theme(legend.position = "right")
    
    ggplotly(p)
  })
}



