library(shiny)
shinyUI(
    fluidPage(
        includeCSS("./www/bootstrap.css"),

        tags$style(type='text/css', '#select {font-family: Arial; background-color: light grey;}'),
        # tags$style(type='text/css', '#stressors {color: grey;}'),

        navbarPage(
            title = 'AGA Québec Océan 2016 - Activités sociale',

            tabPanel('Nom d\'équipe',
                sidebarPanel(width = 3,
                    h5("Created by:"),
                    tags$a("Econometrics by Simulation", href="http://www.econometricsbysimulation.com"),
                    h5("For details on how data is generated:"),
                    tags$a("Blog Post", href=paste0("http://www.econometricsbysimulation.com/", "2013/19/Shiny-Survey-Tool.html")),
                    h5("Github Repository:"),
                    tags$a("Survey-Tool", href=paste0("https://github.com/EconometricsBySimulation/","Shiny-Demos/tree/master/Survey"))
                ), #sidebarPanel

                mainPanel(width = 4,
                    h5('ajouter un titre ici'),
                    textInput('participants', 'Veuillez sélectionner un nom pour votre équipe', width = '100%')
                ) #mainPanel
            ),

            tabPanel('Quiz 1',
                sidebarPanel(width = 3,
                    # This is intentionally an empty object.
# !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h6(textOutput("save.results_1")),
                    h5("Created by:"),
                    tags$a("Econometrics by Simulation", href="http://www.econometricsbysimulation.com"),
                    h5("For details on how data is generated:"),
                    tags$a("Blog Post", href=paste0("http://www.econometricsbysimulation.com/", "2013/19/Shiny-Survey-Tool.html")),
                    h5("Github Repository:"),
                    tags$a("Survey-Tool", href=paste0("https://github.com/EconometricsBySimulation/","Shiny-Demos/tree/master/Survey")),
                    # Display the page counter text.
# !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h5(textOutput("counter_1"))
                ), #sidebarPanel

                # Show a table summarizing the values entered
                mainPanel(width = 7,
                    # Main Action is where most everything is happenning in the
                    # object (where the welcome message, survey, and results appear)
# !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    uiOutput("MainAction_1"),
                    # This displays the action button Next.
# !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    actionButton("Click.Counter_1", "Suivant")
                ) #mainPanel
            ), #tabPanel


            tabPanel('Résultats',
                column(width = 12,
                    selectInput(inputId = 'refresh',
                        label = 'Rafraîchissement automatique',
                        choices = c('Oui','Non'),
                        selected = 'Non')
                ),
                column(width = 12,
                    h5('ok ici on va montrer les résultats'),
                    plotOutput('results', width = "100%", height = "400px")
                )
            )











        ) #navbarPage
    ) #fluidPage
)
