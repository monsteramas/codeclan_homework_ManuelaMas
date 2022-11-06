library(shiny)
library(CodeClanData)
library(bslib)

all_genres <- unique(game_sales$genre)


# With this dashboard I want to show the distribution of critic scores and user scores
# for any given combination of rating and genre, split by game developer.
# For example, when the distribution is skewed towards the top right, 
# it means that games from a certain developer are appreciated by both users and critics.

ui <- fluidPage(
  theme = bs_theme(bootswatch = "minty"),
  titlePanel(tags$h1("Game Score Distribution by Developer", style = "text-align: center")),
  hr(),
  br(),
  sidebarLayout(
    sidebarPanel(
      radioButtons("rating_input",
                   tags$b("Audience"),
                   choices = c(
                     "Everyone" = "E",
                     "10+" = "E10+",
                     "Mature" = "M",
                     "Teenagers" = "T")
                   ),
      
      selectInput("genre_input",
                  tags$b("Genre"),
                  choices = all_genres)
      ),
    
    mainPanel(
      plotOutput("score_plot")
    )
  )
)

server <- function(input, output) {
  
  output$score_plot <- renderPlot({
    game_sales %>%
      filter(
        rating == input$rating_input,
        genre == input$genre_input
      ) %>%
      ggplot() +
      aes(
        x = user_score,
        y = critic_score
      ) +
      geom_point(size = .5, alpha = 0.5) +
      labs(
        x = "User Score (0-10)",
        y = "Critic Score (0-100)"
      ) + 
      facet_wrap(~ developer)
  })
  
}

shinyApp(ui, server)
