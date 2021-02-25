
library(shiny)
library(shinydashboard)
library(prettyR)

addResourcePath("www", "E:/Code/feb-24-a/www")


ui <- fluidPage(
    dashboardPage(
        dashboardHeader(title = "Code Bench"),
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
            

            cwd <- getwd()
            setwd("E://Code//feb-24-a//www")
            print(getwd())
            on.exit(setwd(cwd)) 
            
            code_text <- input$Coding_editor
            
            rcon<-file("code.R","w")
            cat(code_text,file=rcon)
            print(code_text)
            close(rcon)
            R2html("code.R", "out_html.html",browse = FALSE, title = "",bgcolor="#FFFFFF")
            

            print(getwd())
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
