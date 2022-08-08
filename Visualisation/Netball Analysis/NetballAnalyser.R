library(ggplot2)
library(shiny)
library(dbplyr)
library(dplyr)

df = read.csv("data/SilverFernsResults.csv")

df$WIN <- df$NZ.SCORE > df$OPP.SCORE

#jam <- filter(df, OPP=="JAM") %>% select(YEAR, OPP, COUNTRY, NZ.SCORE, OPP..SCORE, WIN)
#aus <- filter(df, OPP=="AUS") %>% select(YEAR, OPP, COUNTRY, NZ.SCORE, OPP..SCORE, WIN)
#eng <- filter(df, OPP=="ENG") %>% select(YEAR, OPP, COUNTRY, NZ.SCORE, OPP..SCORE, WIN)
#rsa <- filter(df, OPP=="RSA") %>% select(YEAR, OPP, COUNTRY, NZ.SCORE, OPP..SCORE, WIN)

countries <- unique(df$OPP)
events <- unique(df$EVENT)

ui <- fluidPage({
  sidebarLayout(
    sidebarPanel(
      sliderInput("years", "choose a time period", min=1948, max=2022, sep="", value=c(1948,2022)),
      checkboxGroupInput("eventselect",
                         "Choose Events:",
                         choices = events,
                         selected = c("Commonwealth Games", "Netball World Cup", "Constellation Cup")),
      checkboxGroupInput("countryselect",
                         "Choose Countries:",
                         choices = countries,
                         selected = c("AUS", "ENG", "JAM", "RSA"))
    ),
    mainPanel(
      plotOutput("winPlot")
    )
  )
})

server <- function(input, output) {
  filterResults <- reactive({
    filter(df, EVENT %in% input$eventselect, OPP %in% input$countryselect, YEAR %in% c(input$years[1]:input$years[2])) %>% group_by(OPP)
  })
  
  output$winPlot <- renderPlot({
    df.summary <- summarize(filterResults(), total.W = sum(WIN), total.L = sum(!WIN))
    numTeams <- length(df.summary$OPP)
    df2 <- data.frame(name = rep(df.summary$OPP, 2), result = c(rep("W", numTeams), rep("L", numTeams)), matches = c(df.summary$total.W, df.summary$total.L))
    ggplot(df2, aes(x = name, y = matches, fill = result)) + 
      geom_bar(position="dodge", stat="identity") +
      scale_fill_manual(values = c("W" = "green", "L" = "red")) +
      coord_flip() +
      xlab("Team") +
      ylab("Number of Matches")
  })
}

shinyApp(ui = ui, server = server)