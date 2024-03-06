library(shiny)
library(plotly)
source("ui.R")
source("server.R")
library(rsconnect)


# Runs the application (both ui and server)
shinyApp(ui = ui, server = server)