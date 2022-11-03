library(shiny)
library(tidyverse)
library(CodeClanData)

whisky <- CodeClanData::whisky %>%
  janitor::clean_names()

all_regions <- unique(whisky$region)

ui <- fluidPage(
  titlePanel("Scent of a Whisky"),
  plotOutput("whisky_plot"),
  fluidRow(
    column(
      6,
      selectInput("region_input",
        "Which Region?",
        choices = all_regions
      )
    ),
    column(
      6,
      uiOutput("distillery_input")
    )
  )
)

server <- function(input, output) {
  output$distillery_input <- renderUI(selectInput(
    "distillery_input",
    "Which Distillery?",
    choices = whisky %>%
               filter(region == input$region_input) %>%
               select(distillery)
  ))

  output$whisky_plot <- renderPlot({
    whisky %>% 
      pivot_longer(cols = 7:18, names_to = "tasting_notes", values_to = "value") %>% 
      filter(distillery == input$distillery_input) %>% 
      ggplot() +
      geom_col(aes(x = tasting_notes, y = value)) +
      labs(x = "Tasting Notes", y = "Value")
  })

}

shinyApp(ui, server)
