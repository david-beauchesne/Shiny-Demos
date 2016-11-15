library(shiny)
shinyUI(
    fluidPage(
        includeCSS("./www/bootstrap.css"),

        tags$style(type='text/css', '#select {font-family: Arial; background-color: light grey;}'),
        # tags$style(type='text/css', '#stressors {color: grey;}'),

        navbarPage(
            title = 'AGA Québec Océan 2016 - Activités sociales',

            tabPanel('Nom d\'équipe',
                sidebarPanel(width = 3,
                    h5("Créé par:"),
                    h6("Le comité étudiant de Québec Océan"),
                    h5("Dépôt Github :"),
                    tags$a("Code source quiz", href=paste0("https://github.com/david-beauchesne/SurveyTool")),
                    h5("Lien vers l'outil de réseautage :"),
                    tags$a("AGA 2016 Réseautage", href=paste0("https://bit.ly/AGA-QO2016"))
                ), #sidebarPanel

                mainPanel(width = 4,
                    h5('Bienvenue aux activités sociales de l\'AGA 2015 de Québec Océan!'),
                    h6('Préparées par votre comité étudiant'),
                    br(),
                    h5('Commençons par le début, s\'identifier en tant qu\'équipe'),
                    br(),
                    textInput('participants', 'Veuillez sélectionner un nom pour votre équipe', width = '100%')
                ) #mainPanel
            ),

            tabPanel('Membres QO',
                sidebarPanel(width = 3,
                    # This is intentionally an empty object.
# !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h6(textOutput("save.results_1")),
                    h5("Créé par:"),
                    h6("Le comité étudiant de Québec Océan"),
                    h5("Dépôt Github :"),
                    tags$a("Code source quiz", href=paste0("https://github.com/david-beauchesne/SurveyTool")),
                    h5("Lien vers l'outil de réseautage :"),
                    tags$a("AGA 2016 Réseautage", href=paste0("https://bit.ly/AGA-QO2016")),
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


            tabPanel('Avantages QO',
                sidebarPanel(width = 3,
                    # This is intentionally an empty object.
# !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h6(textOutput("save.results_2")),
                    h5("Créé par:"),
                    h6("Le comité étudiant de Québec Océan"),
                    h5("Dépôt Github :"),
                    tags$a("Code source quiz", href=paste0("https://github.com/david-beauchesne/SurveyTool")),
                    h5("Lien vers l'outil de réseautage :"),
                    tags$a("AGA 2016 Réseautage", href=paste0("https://bit.ly/QO2015")),
                    # Display the page counter text.
# !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h5(textOutput("counter_2"))
                ), #sidebarPanel

                # Show a table summarizing the values entered
                mainPanel(width = 7,
                    # Main Action is where most everything is happenning in the
                    # object (where the welcome message, survey, and results appear)
# !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    uiOutput("MainAction_2"),
                    # This displays the action button Next.
# !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    actionButton("Click.Counter_2", "Suivant")
                ) #mainPanel
            ), #tabPanel


            tabPanel('Océanographie générale 1',
                sidebarPanel(width = 3,
                    # This is intentionally an empty object.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h6(textOutput("save.results_3")),
                    h5("Créé par:"),
                    h6("Le comité étudiant de Québec Océan"),
                    h5("Dépôt Github :"),
                    tags$a("Code source quiz", href=paste0("https://github.com/david-beauchesne/SurveyTool")),
                    h5("Lien vers l'outil de réseautage :"),
                    tags$a("AGA 2016 Réseautage", href=paste0("https://bit.ly/QO2015")),
                    # Display the page counter text.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h5(textOutput("counter_3"))
                ), #sidebarPanel

                # Show a table summarizing the values entered
                mainPanel(width = 7,
                    # Main Action is where most everything is happenning in the
                    # object (where the welcome message, survey, and results appear)
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    uiOutput("MainAction_3"),
                    # This displays the action button Next.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    actionButton("Click.Counter_3", "Suivant")
                ) #mainPanel
            ), #tabPanel

            tabPanel('Saint-Laurent - Arctique 1',
                sidebarPanel(width = 3,
                    # This is intentionally an empty object.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h6(textOutput("save.results_4")),
                    h5("Créé par:"),
                    h6("Le comité étudiant de Québec Océan"),
                    h5("Dépôt Github :"),
                    tags$a("Code source quiz", href=paste0("https://github.com/david-beauchesne/SurveyTool")),
                    h5("Lien vers l'outil de réseautage :"),
                    tags$a("AGA 2016 Réseautage", href=paste0("https://bit.ly/QO2015")),
                    # Display the page counter text.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h5(textOutput("counter_4"))
                ), #sidebarPanel

                # Show a table summarizing the values entered
                mainPanel(width = 7,
                    # Main Action is where most everything is happenning in the
                    # object (where the welcome message, survey, and results appear)
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    uiOutput("MainAction_4"),
                    # This displays the action button Next.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    actionButton("Click.Counter_4", "Suivant")
                ) #mainPanel
            ), #tabPanel

            tabPanel('Océanographie générale 2',
                sidebarPanel(width = 3,
                    # This is intentionally an empty object.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h6(textOutput("save.results_5")),
                    h5("Créé par:"),
                    h6("Le comité étudiant de Québec Océan"),
                    h5("Dépôt Github :"),
                    tags$a("Code source quiz", href=paste0("https://github.com/david-beauchesne/SurveyTool")),
                    h5("Lien vers l'outil de réseautage :"),
                    tags$a("AGA 2016 Réseautage", href=paste0("https://bit.ly/QO2015")),
                    # Display the page counter text.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h5(textOutput("counter_5"))
                ), #sidebarPanel

                # Show a table summarizing the values entered
                mainPanel(width = 7,
                    # Main Action is where most everything is happenning in the
                    # object (where the welcome message, survey, and results appear)
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    uiOutput("MainAction_5"),
                    # This displays the action button Next.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    actionButton("Click.Counter_5", "Suivant")
                ) #mainPanel
            ), #tabPanel

            tabPanel('Saint-Laurent - Arctique 2',
                sidebarPanel(width = 3,
                    # This is intentionally an empty object.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h6(textOutput("save.results_6")),
                    h5("Créé par:"),
                    h6("Le comité étudiant de Québec Océan"),
                    h5("Dépôt Github :"),
                    tags$a("Code source quiz", href=paste0("https://github.com/david-beauchesne/SurveyTool")),
                    h5("Lien vers l'outil de réseautage :"),
                    tags$a("AGA 2016 Réseautage", href=paste0("https://bit.ly/QO2015")),
                    # Display the page counter text.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    h5(textOutput("counter_6"))
                ), #sidebarPanel

                # Show a table summarizing the values entered
                mainPanel(width = 7,
                    # Main Action is where most everything is happenning in the
                    # object (where the welcome message, survey, and results appear)
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    uiOutput("MainAction_6"),
                    # This displays the action button Next.
            # !! CHANGE PARAMETER NAME FOR MULTIPLE INSTANCES !!
                    actionButton("Click.Counter_6", "Suivant")
                ) #mainPanel
            ), #tabPanel



            tabPanel('Résultats',
                column(width = 12,
                    h5('Résultats par équipe'),
                    plotOutput('results', width = "100%", height = "600px")
                )
            )











        ) #navbarPage
    ) #fluidPage
)
