
library(shiny)
library(shinydashboard)
library(prettyR)
library(R2HTML)

addResourcePath("www", "E:/Qualitest/Code/feb-24-a/www")
setwd("E:/Qualitest/Code/feb-24-a/www")

ui <- fluidPage(
    dashboardPage(
        dashboardHeader(title = "Live Coding"),
        dashboardSidebar(),
        dashboardBody(
            
            fluidRow(
                
                column(5,
                       shinyAce::aceEditor(outputId = "Coding_editor",
                                           theme = "chrome",
                                           mode = "r",
                                           height = "600px",
                                           tabSize = 4,
                                           selectionId = "selection",
                                           value = "",
                                           placeholder = "type your query here...") 
                ),
                column(1,
                       actionButton(width=NULL, inputId="actionButton_1", icon=NULL, label="Execute")
                       
                ),
                column(6,
                       htmlOutput('htmlOutput_2')
                )
                
            )
            
        )
    )            
    
)




server <- function(input, output) {
    
    observeEvent(input$actionButton_1, {

            code_text <- input$Coding_editor
            code_2 <- eval(parse(text=gsub('\r','', code_text, fixed = TRUE)))
            rcon<-file("code.R","w")
            cat(code_text,file=rcon)
            print(code_text)
            close(rcon)
            R2html("code.R", "www/out_html.html",browse = FALSE, title = "")

            output$htmlOutput_2 <- renderUI({
                    tags$iframe(
                    seamless="seamless",
                    src="www/out_html_list.html",
                    height=600, width=635)
            
            })
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
