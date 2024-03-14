# Lets make a Shiny app to present my simulations

library(shiny)
library(tidyverse)
library(here)

#load in simulation data

load(here("data","onegambound_3_11.Rdata"))

#Filter the data to exclude betak of -0.9 and sigmaw of .1
onegambound_3_11 <- one_gambound_3_11 %>%
  filter(betak != -0.9, sigmaw != 0.1)

# Create a Shiny UI from the one_gambound_3_11 data. With a dropdown input for sigmaw, a, and wtrig. 
ui <- fluidPage(
  titlePanel("Simulation of One-Gamete Bound"),
  sidebarLayout(
    sidebarPanel(
      selectInput("sigmaw", "Select Sigmaw", choices = unique(one_gambound_3_11$sigmaw)),
      selectInput("a", "Select a", choices = unique(one_gambound_3_11$a)),
      selectInput("wtrig", "Select Wtrig", choices = unique(one_gambound_3_11$wtrig))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)


# Create a shiny server function from the one_gambound_3_11 data with a reactive function to filter the data and make a bar plot of betak versus pec_h and fill with alphak.
server <- function(input, output) {
  filtered_data <- reactive({
    one_gambound_3_11 %>%
      filter(sigmaw == input$sigmaw, a == input$a, wtrig == input$wtrig)
  })
  
  output$plot <- renderPlot({
    ggplot(filtered_data(), aes(x = betak, y = pct_h, fill = alphak)) +
      geom_bar(stat = "identity") +
      labs(title = "One Game Bound",
           x = "betak",
           y = "pct_u")
  })
}

runApp(list(ui = ui, server = server))
