library(dbplyr)
library(dplyr)
library(ggplot2)
library(shiny)

df <- read.csv("data/ANZ_Premiership_2017_2022.csv")
colours <- c("Central Pulse" = "yellow", "Mainland Tactix" = "red", "Waikato Bay of Plenty Magic" = "black", "Southern Steel" = "pink", "Northern Mystics" = "darkblue", "Northern Stars" = "lightblue")
teams <-c(
  "Northern Mystics",
  "Northern Stars",
  "Waikato Bay of Plenty Magic",
  "Central Pulse",
  "Mainland Tactix",
  "Southern Steel"
)

ui <- fluidPage(
  titlePanel("ANZ Premiership Visualiser"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("teams",
                  "Choose teams:",
                  choices = teams,
                  selected = teams),
      sliderInput("years", "Choose years", sep="",
                  min=2017, max=2022, value=c(2017,2022))
    ),
    mainPanel(
      h3("Wins / Losses / Draws"),
      plotOutput("winPlot"),
      h3("Standings"),
      plotOutput("standingsPlot"),
      h3("Goals For / Against"),
      plotOutput("goalsPlot")
    )
  )
)

server <- function(input, output) {

  filterTeams <- reactive({
    df.selection <- filter(df, Team %in% input$teams) 
    group_by(df.selection, Team)
  })
  
  filterTeamsAndYears <- reactive({
    df.selection <- filter(df, Team %in% input$teams, Year %in% (input$years[1]:input$years[2]))
    group_by(df.selection, Team)
  })

  output$winPlot <- renderPlot({
    df.summary <- summarize(filterTeamsAndYears(), total.W = sum(W), total.L = sum(L), total.D = sum(D))
    numTeams <- length(df.summary$Team)
    df2 <- data.frame(name = rep(df.summary$Team, 3), result = c(rep("W", numTeams), rep("L", numTeams), rep("D", numTeams)), matches = c(df.summary$total.W, df.summary$total.L, df.summary$total.D))
    ggplot(df2, aes(x = name, y = matches, fill = result)) + 
      geom_bar(position="stack", stat="identity") +
      scale_fill_manual(values = c("W" = "green", "L" = "red", "D" = "blue")) +
      coord_flip() +
      xlab("Team") +
      ylab("Number of Matches")
  })
  
  output$standingsPlot <- renderPlot({
    ggplot(filterTeamsAndYears(), aes(x = Year, y = desc(Pos), group = Team)) + 
      geom_line(aes(color=Team), size = 3) +
      scale_colour_manual(values = colours) +
      xlab("Team") +
      ylab("Ladder Position")
  })
  
  output$goalsPlot <- renderPlot({
    df.summary <- summarize(filterTeamsAndYears(), total.GF = sum(GF), total.GA = sum(GA), total.W = sum(W))
    ggplot(df.summary, aes(x=total.GF, y=total.GA, size=total.W, color=Team)) + 
      geom_point() +
      scale_colour_manual(values = colours) +
      expand_limits(x = 0, y = 0)
  })
  
}
  
  
shinyApp(ui = ui, server = server)


#df[order(-df$W),]
#df[df$W >= mean(df$W) * 1.25, ]
#df[df$W > 10 | df$W < 5, ]
#df[df$Team %in% c("Central Pulse", "Waikato Bay of Plenty Magic"),]

#select(df, Team, W, L)

#summarize(df, avg.W = mean(W))

#df.teams <- group_by(df, Team)

#summarize(df.teams, avg.W = mean(W))