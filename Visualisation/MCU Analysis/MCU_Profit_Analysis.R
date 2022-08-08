library(ggplot2)
library(dbplyr)
library(dplyr)
library(ggplot2)
library(scales)

df <- read.csv("data/mcu_box_office.csv")
df["profit"] <- df["worldwide_box_office"] - df["production_budget"]
colours <- c("One" = "#bdd7e7", "Two" = "#6baed6", "Three" = "#2171b5", "Four" = "red")
phases <- c("One", "Two", "Three", "Four")

ui <- fluidPage(
  titlePanel("MCU Analyser"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selector", "Choose movie selection", choices=c("All movies" = "ALL", "Avengers movies only" = "AVENGERS", "Solo titles only" = "SOLO")),
      checkboxGroupInput("phases",
                         "Choose Phases:",
                         choices = phases,
                         selected = phases),
      sliderInput("years", "Choose years", sep="",
                  min=2008, max=2022, value=c(2008,2022),
                  animate=animationOptions(interval = 1000)),
      actionButton("speed", "Click to speed up the Internet")
#      actionButton("go", "Go")
    ),
    mainPanel(
      h2("Chart Tabs"),
      tabsetPanel(
        tabPanel("Profits by Movie", plotOutput("profits")),
        tabPanel("Audience Score Chart",plotOutput("audiencescore")),
        tabPanel("Critics vs Audience Score", plotOutput("critical"))  
      )
    )
)
)

server <- function(input, output) {
  
  filterMovies <- reactive({
#  filterMovies <- eventReactive(input$go, {
    if (input$selector == "ALL") {
      df.selection <- filter(df, mcu_phase %in% input$phases, year %in% (input$years[1]:input$years[2])) 
    } else {
      df.selection <- filter(df, mcu_phase %in% input$phases, type==input$selector, year %in% (input$years[1]:input$years[2])) 
    }
    group_by(df.selection, mcu_phase) %>% mutate(mcu_phase = factor(mcu_phase, levels=c("One", "Two", "Three", "Four"))) 
  })
  
  output$profits <- renderPlot({
    filterMovies() %>%
      ggplot(aes(x=reorder(movie_title,profit), y=profit, fill=mcu_phase)) + 
        geom_bar(stat = "identity") + 
        coord_flip() +
        scale_fill_manual(values = colours) +
        ylab("Profit (Worldwide Box Office - Production Budget)") +
        xlab("Movie") +
        scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))
    
  })
  
  output$audiencescore <- renderPlot({
    filterMovies() %>% 
      ggplot(aes(x=mcu_phase, y=audience_score)) + 
        geom_point(size = 2) +
        geom_errorbar(stat = "summary", width=0.6, aes(ymax=..y.., ymin=..y.., group=mcu_phase), color="black") +
        expand_limits(x = 0, y = 0) +
        xlab("MCU Phase") +
        ylab("Audience Score")
    
  })
  
  output$critical <- renderPlot({
    filterMovies() %>% 
      ggplot(aes(x=tomato_meter, y=audience_score, color=mcu_phase)) + 
      geom_point(size = 4) +
      expand_limits(x = 0, y = 0) +
      scale_colour_manual(values = colours) +
      xlab("Tomato Meter") +
      ylab("Audience Score")
  })
  
  observeEvent(input$speed, {
    print("A request has been made to speed up the Internet")
  })
  
  
}

shinyApp(ui = ui, server = server)

