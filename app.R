# Load Packages
library(shiny)
library(gsheet)
library(plyr)

# Google Doc URLs
url_data <- "https://docs.google.com/spreadsheets/d/1Uf8HiryD2FsQ4XIN-5189DoWDjhR6k1Qj6uJBzKeoyE/edit?usp=sharing"
url_schedule <- "https://docs.google.com/spreadsheets/d/1UF5l4McPokRt3Vc-csWJxsSUHEMiwpy9hh6Ifo3d2gc/edit?usp=sharing"

# Load Data, only games that have been played
data <- gsheet2tbl(url = url_data)
data <- data[data$Complete == "Y", ]
# Load Schedule
schedule <- gsheet2tbl(url = url_schedule)

# Create Standings Table
standings <- ddply(data, .(TeamName), summarise,
                   Wins = sum(Win),
                   Losses = length(TeamName[Win == 0]),
                   Runs = sum(RunsScored)
)
standings <- standings[order(-standings$Wins, -standings$Runs), ]

# User-interface Script
ui <- fluidPage(
  titlePanel("Booth's Funday Tuesday Fall Ball Extravaganza"),
  tableOutput("schedule"),
  tableOutput("standings")
)
# Server Script
server <- function(input, output) {
  output$schedule <- renderTable({
    schedule
  }, include.rownames = FALSE)
  
  output$standings <- renderTable({
    standings
  }, include.rownames = FALSE)
}
# Shiny App
shinyApp(ui = ui, server = server)