library(shiny)
library(rdrop2)
library(stringr)
source('./loadData.r')
token <- readRDS("droptoken.rds")

# Read the survey questions for multiple quizzes
# Save questions as a list of questions for multiple quizzes
load('./Qlist.RData') # Quiz list with questions in individual matrices with col structure = c(Question number, Question, choices as multiple columns)
load('./Alist.RData') # Quiz answers with structure = structure(Qlist), col = c(Question number, Answer)
Qlist_1 <- Qlist[[1]]
Qlist_2 <- Qlist[[2]]
Qlist_3 <- Qlist[[3]]
Qlist_4 <- Qlist[[4]]
Qlist_5 <- Qlist[[5]]
Qlist_6 <- Qlist[[6]]

Alist_1 <- Alist[[1]]
Alist_2 <- Alist[[2]]
Alist_3 <- Alist[[3]]
Alist_4 <- Alist[[4]]
Alist_5 <- Alist[[5]]
Alist_6 <- Alist[[6]]


pt <- 1
nQuiz <- 6

shinyServer(function(input, output) {


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# --------------------------------- Quiz 1 ------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

    # There could be a way to automate the quiz selection and tab generation as a function of the length of Qlist, but no time or interest for it at this point

      # Create an empty vector to hold survey results
      drop_get('/phd/misc/surveytool/survey/plot_table.RDS', dtoken = token, overwrite = TRUE)
      results_1 <<- rep("", nrow(Qlist_1))
      grade_1 <<- 0
      # Empty table to store results for plotOutput

      # Name each element of the vector based on the
      # second column of the Qlist
      names(results_1)  <<- Qlist_1[,2]

      # Hit counter
      output$counter_1 <-
        renderText({
          if (!file.exists("./counter_1.Rdata")) counter_1 <- 0
          if (file.exists("./counter_1.Rdata")) load(file="./counter_1.Rdata")
          counter_1 <- counter_1 <<- counter_1 + 1

          save(counter_1, file="./counter_1.Rdata")
          paste0("Hits: ", counter_1)
        })


      # This renderUI function holds the primary actions of the
      # survey area.
      output$MainAction_1 <- renderUI( {
        dynamicUi_1()
      })

      # Dynamic UI is the interface which changes as the survey
      # progresses.
      dynamicUi_1 <- reactive({
        # Initially it shows a welcome message.
        if (input$Click.Counter_1==0)
          return(
            list(
            h5('Ce premier quiz vise à tester vos connaissances générales sur Québec Océan!'),
            h5('Mise en garde :'),
            h5('N\'essayez pas de faire un retour vers l\'arrière, vous devrez tout recommencer!')
            )
          )

        # Once the next button has been clicked once we see each question
        # of the survey.
        if (input$Click.Counter_1>0 & input$Click.Counter_1<=nrow(Qlist_1)) {
          return(
            list(
              h5(textOutput("question_1")),
              radioButtons("survey_1", "Veuillez sélectionner :", option.list_1())
              )
            )
        }

        # Finally we see results of the survey as well as a
        # download button.
        if (input$Click.Counter_1>nrow(Qlist_1)) {
          return(
            # list(
              h4("Merci pour votre participation!")
            #   )
            )
        }
      })

      # This reactive function is concerned primarily with
      # saving the results of the survey for this individual.
      output$save.results_1 <- renderText({
        # After each click, save the results of the radio buttons.
        if ((input$Click.Counter_1>0)&(input$Click.Counter_1>!nrow(Qlist_1)))
          try(results_1[input$Click.Counter_1] <<- input$survey_1)
          # try is used because there is a brief moment in which
          # the if condition is true but input$survey = NULL

        # If the user has clicked through all of the survey questions
        # then R saves the results to the survey file.
        if (input$Click.Counter_1==nrow(Qlist_1)+1) {
        #   if (file.exists("./survey.results_1.Rdata")) {
          if (file.exists(paste('./results_files/', input$participants, 'res_1.RData', sep = ''))) {

              load(file=paste('./results_files/', input$participants, 'res_1.RData', sep = ''))
            #   load(file="./survey.results_1.Rdata")

              rn <- rownames(presults_1)
          }

          if (!file.exists(paste('./results_files/', input$participants, 'res_1.RData', sep = ''))) {
        #   if (!file.exists("./survey.results_1.Rdata")) {
              presults_1 <- rn <- NULL
          }

          rn <- c(rn,input$participants)
          presults_1 <- rbind(presults_1, results_1)
          rownames(presults_1) <- rn
          save(presults_1, file=paste('./results_files/', input$participants, 'res_1.RData', sep = ''))
        #   save(presults_1, file="./survey.results_1.Rdata")

        drop_upload(paste('./results_files/', input$participants, 'res_1.RData', sep = ''), dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)



          # Automatic grading of answers
          grade_1 <- sum(as.numeric(Alist_1[,2] == presults_1[input$participants, 1:nrow(Qlist_1)]) * pt)
          names(grade_1) <- paste(input$participants, '_1', sep='')


           write.csv(grade_1, paste('./', input$participants, '_1.csv', sep=''), row.names = TRUE, quote = TRUE, fileEncoding = 'UTF-8')
           drop_upload(paste('./', input$participants, '_1.csv', sep=''), dest = '/PhD/Misc/SurveyTool/Survey/Server_files', dtoken = token)

            plot_table <- loadData()
            saveRDS(plot_table, file = './plot_table.RDS')

            drop_upload('./plot_table.RDS', dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)

        }
        # Because there has to be a UI object to call this function I set up render text that distplays the content of this funciton.
        ""
      })

      #
      # The option list is a reative list of elements that updates itself when the click counter is advanced.
      option.list_1 <- reactive({
        qlist_1 <- Qlist_1[input$Click.Counter_1,3:ncol(Qlist_1)]
        # Remove items from the qlist if the option is empty.
        # Also, convert the option list to matrix.
        as.matrix(qlist_1[qlist_1!=""])
      })

      # This function show the question number (Q:)
      # Followed by the question text.
      output$question_1 <- renderText({
        paste0(
          "Q", input$Click.Counter_1,": ",
          Qlist_1[input$Click.Counter_1,2]
        )
      })


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# --------------------------------- Quiz 2 ------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

  # There could be a way to automate the quiz selection and tab generation as a function of the length of Qlist, but no time or interest for it at this point

    # Create an empty vector to hold survey results
    drop_get('/phd/misc/surveytool/survey/plot_table.RDS', dtoken = token, overwrite = TRUE)
    results_2 <<- rep("", nrow(Qlist_2))
    grade_2 <<- 0
    # Empty table to store results for plotOutput

    # Name each element of the vector based on the
    # second column of the Qlist
    names(results_2)  <<- Qlist_2[,2]

    # Hit counter
    output$counter_2 <-
      renderText({
        if (!file.exists("./counter_2.Rdata")) counter_2 <- 0
        if (file.exists("./counter_2.Rdata")) load(file="./counter_2.Rdata")
        counter_2 <- counter_2 <<- counter_2 + 1

        save(counter_2, file="./counter_2.Rdata")
        paste0("Hits: ", counter_2)
      })


    # This renderUI function holds the primary actions of the
    # survey area.
    output$MainAction_2 <- renderUI( {
      dynamicUi_2()
    })

    # Dynamic UI is the interface which changes as the survey
    # progresses.
    dynamicUi_2 <- reactive({
      # Initially it shows a welcome message.
      if (input$Click.Counter_2==0)
        return(
          list(
          h5('Ce premier quiz vise à tester vos connaissances générales sur Québec Océan!'),
          h5('Mise en garde :'),
          h5('N\'essayez pas de faire un retour vers l\'arrière, vous devrez tout recommencer!')
          )
        )

      # Once the next button has been clicked once we see each question
      # of the survey.
      if (input$Click.Counter_2>0 & input$Click.Counter_2<=nrow(Qlist_2)) {
        return(
          list(
            h5(textOutput("question_2")),
            radioButtons("survey_2", "Veuillez sélectionner :", option.list_2())
            )
          )
      }

      # Finally we see results of the survey as well as a
      # download button.
      if (input$Click.Counter_2>nrow(Qlist_2)) {
        return(
          # list(
            h4("Merci pour votre participation!")
          #   )
          )
      }
    })

    # This reactive function is concerned primarily with
    # saving the results of the survey for this individual.
    output$save.results_2 <- renderText({
      # After each click, save the results of the radio buttons.
      if ((input$Click.Counter_2>0)&(input$Click.Counter_2>!nrow(Qlist_2)))
        try(results_2[input$Click.Counter_2] <<- input$survey_2)
        # try is used because there is a brief moment in which
        # the if condition is true but input$survey = NULL

      # If the user has clicked through all of the survey questions
      # then R saves the results to the survey file.
      if (input$Click.Counter_2==nrow(Qlist_2)+1) {
      #   if (file.exists("./survey.results_2.Rdata")) {
        if (file.exists(paste('./results_files/', input$participants, 'res_2.RData', sep = ''))) {

            load(file=paste('./results_files/', input$participants, 'res_2.RData', sep = ''))
          #   load(file="./survey.results_2.Rdata")

            rn <- rownames(presults_2)
        }

        if (!file.exists(paste('./results_files/', input$participants, 'res_2.RData', sep = ''))) {
      #   if (!file.exists("./survey.results_2.Rdata")) {
            presults_2 <- rn <- NULL
        }

        rn <- c(rn,input$participants)
        presults_2 <- rbind(presults_2, results_2)
        rownames(presults_2) <- rn
        save(presults_2, file=paste('./results_files/', input$participants, 'res_2.RData', sep = ''))
      #   save(presults_2, file="./survey.results_2.Rdata")

      drop_upload(paste('./results_files/', input$participants, 'res_2.RData', sep = ''), dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)



        # Automatic grading of answers
        grade_2 <- sum(as.numeric(Alist_2[,2] == presults_2[input$participants, 1:nrow(Qlist_2)]) * pt)
        names(grade_2) <- paste(input$participants, '_2', sep='')


         write.csv(grade_2, paste('./', input$participants, '_2.csv', sep=''), row.names = TRUE, quote = TRUE, fileEncoding = 'UTF-8')
         drop_upload(paste('./', input$participants, '_2.csv', sep=''), dest = '/PhD/Misc/SurveyTool/Survey/Server_files', dtoken = token)

          plot_table <- loadData()
          saveRDS(plot_table, file = './plot_table.RDS')

          drop_upload('./plot_table.RDS', dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)

      }
      # Because there has to be a UI object to call this function I set up render text that distplays the content of this funciton.
      ""
    })

    #
    # The option list is a reative list of elements that updates itself when the click counter is advanced.
    option.list_2 <- reactive({
      qlist_2 <- Qlist_2[input$Click.Counter_2,3:ncol(Qlist_2)]
      # Remove items from the qlist if the option is empty.
      # Also, convert the option list to matrix.
      as.matrix(qlist_2[qlist_2!=""])
    })

    # This function show the question number (Q:)
    # Followed by the question text.
    output$question_2 <- renderText({
      paste0(
        "Q", input$Click.Counter_2,": ",
        Qlist_2[input$Click.Counter_2,2]
      )
    })

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# --------------------------------- Quiz 3 ------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

    # There could be a way to automate the quiz selection and tab generation as a function of the length of Qlist, but no time or interest for it at this point

      # Create an empty vector to hold survey results
      drop_get('/phd/misc/surveytool/survey/plot_table.RDS', dtoken = token, overwrite = TRUE)
      results_3 <<- rep("", nrow(Qlist_3))
      grade_3 <<- 0
      # Empty table to store results for plotOutput

      # Name each element of the vector based on the
      # second column of the Qlist
      names(results_3)  <<- Qlist_3[,2]

      # Hit counter
      output$counter_3 <-
        renderText({
          if (!file.exists("./counter_3.Rdata")) counter_3 <- 0
          if (file.exists("./counter_3.Rdata")) load(file="./counter_3.Rdata")
          counter_3 <- counter_3 <<- counter_3 + 1

          save(counter_3, file="./counter_3.Rdata")
          paste0("Hits: ", counter_3)
        })


      # This renderUI function holds the primary actions of the
      # survey area.
      output$MainAction_3 <- renderUI( {
        dynamicUi_3()
      })

      # Dynamic UI is the interface which changes as the survey
      # progresses.
      dynamicUi_3 <- reactive({
        # Initially it shows a welcome message.
        if (input$Click.Counter_3==0)
          return(
            list(
            h5('Ce premier quiz vise à tester vos connaissances générales sur Québec Océan!'),
            h5('Mise en garde :'),
            h5('N\'essayez pas de faire un retour vers l\'arrière, vous devrez tout recommencer!')
            )
          )

        # Once the next button has been clicked once we see each question
        # of the survey.
        if (input$Click.Counter_3>0 & input$Click.Counter_3<=nrow(Qlist_3)) {
          return(
            list(
              h5(textOutput("question_3")),
              radioButtons("survey_3", "Veuillez sélectionner :", option.list_3())
              )
            )
        }

        # Finally we see results of the survey as well as a
        # download button.
        if (input$Click.Counter_3>nrow(Qlist_3)) {
          return(
            # list(
              h4("Merci pour votre participation!")
            #   )
            )
        }
      })

      # This reactive function is concerned primarily with
      # saving the results of the survey for this individual.
      output$save.results_3 <- renderText({
        # After each click, save the results of the radio buttons.
        if ((input$Click.Counter_3>0)&(input$Click.Counter_3>!nrow(Qlist_3)))
          try(results_3[input$Click.Counter_3] <<- input$survey_3)
          # try is used because there is a brief moment in which
          # the if condition is true but input$survey = NULL

        # If the user has clicked through all of the survey questions
        # then R saves the results to the survey file.
        if (input$Click.Counter_3==nrow(Qlist_3)+1) {
        #   if (file.exists("./survey.results_3.Rdata")) {
          if (file.exists(paste('./results_files/', input$participants, 'res_3.RData', sep = ''))) {

              load(file=paste('./results_files/', input$participants, 'res_3.RData', sep = ''))
            #   load(file="./survey.results_3.Rdata")

              rn <- rownames(presults_3)
          }

          if (!file.exists(paste('./results_files/', input$participants, 'res_3.RData', sep = ''))) {
        #   if (!file.exists("./survey.results_3.Rdata")) {
              presults_3 <- rn <- NULL
          }

          rn <- c(rn,input$participants)
          presults_3 <- rbind(presults_3, results_3)
          rownames(presults_3) <- rn
          save(presults_3, file=paste('./results_files/', input$participants, 'res_3.RData', sep = ''))
        #   save(presults_3, file="./survey.results_3.Rdata")

        drop_upload(paste('./results_files/', input$participants, 'res_3.RData', sep = ''), dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)



          # Automatic grading of answers
          grade_3 <- sum(as.numeric(Alist_3[,2] == presults_3[input$participants, 1:nrow(Qlist_3)]) * pt)
          names(grade_3) <- paste(input$participants, '_3', sep='')


           write.csv(grade_3, paste('./', input$participants, '_3.csv', sep=''), row.names = TRUE, quote = TRUE, fileEncoding = 'UTF-8')
           drop_upload(paste('./', input$participants, '_3.csv', sep=''), dest = '/PhD/Misc/SurveyTool/Survey/Server_files', dtoken = token)

            plot_table <- loadData()
            saveRDS(plot_table, file = './plot_table.RDS')

            drop_upload('./plot_table.RDS', dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)

        }
        # Because there has to be a UI object to call this function I set up render text that distplays the content of this funciton.
        ""
      })

      #
      # The option list is a reative list of elements that updates itself when the click counter is advanced.
      option.list_3 <- reactive({
        qlist_3 <- Qlist_3[input$Click.Counter_3,3:ncol(Qlist_3)]
        # Remove items from the qlist if the option is empty.
        # Also, convert the option list to matrix.
        as.matrix(qlist_3[qlist_3!=""])
      })

      # This function show the question number (Q:)
      # Followed by the question text.
      output$question_3 <- renderText({
        paste0(
          "Q", input$Click.Counter_3,": ",
          Qlist_3[input$Click.Counter_3,2]
        )
      })

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# --------------------------------- Quiz 4 ------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

  # There could be a way to automate the quiz selection and tab generation as a function of the length of Qlist, but no time or interest for it at this point

    # Create an empty vector to hold survey results
    drop_get('/phd/misc/surveytool/survey/plot_table.RDS', dtoken = token, overwrite = TRUE)
    results_4 <<- rep("", nrow(Qlist_4))
    grade_4 <<- 0
    # Empty table to store results for plotOutput

    # Name each element of the vector based on the
    # second column of the Qlist
    names(results_4)  <<- Qlist_4[,2]

    # Hit counter
    output$counter_4 <-
      renderText({
        if (!file.exists("./counter_4.Rdata")) counter_4 <- 0
        if (file.exists("./counter_4.Rdata")) load(file="./counter_4.Rdata")
        counter_4 <- counter_4 <<- counter_4 + 1

        save(counter_4, file="./counter_4.Rdata")
        paste0("Hits: ", counter_4)
      })


    # This renderUI function holds the primary actions of the
    # survey area.
    output$MainAction_4 <- renderUI( {
      dynamicUi_4()
    })

    # Dynamic UI is the interface which changes as the survey
    # progresses.
    dynamicUi_4 <- reactive({
      # Initially it shows a welcome message.
      if (input$Click.Counter_4==0)
        return(
          list(
          h5('Ce premier quiz vise à tester vos connaissances générales sur Québec Océan!'),
          h5('Mise en garde :'),
          h5('N\'essayez pas de faire un retour vers l\'arrière, vous devrez tout recommencer!')
          )
        )

      # Once the next button has been clicked once we see each question
      # of the survey.
      if (input$Click.Counter_4>0 & input$Click.Counter_4<=nrow(Qlist_4)) {
        return(
          list(
            h5(textOutput("question_4")),
            radioButtons("survey_4", "Veuillez sélectionner :", option.list_4())
            )
          )
      }

      # Finally we see results of the survey as well as a
      # download button.
      if (input$Click.Counter_4>nrow(Qlist_4)) {
        return(
          # list(
            h4("Merci pour votre participation!")
          #   )
          )
      }
    })

    # This reactive function is concerned primarily with
    # saving the results of the survey for this individual.
    output$save.results_4 <- renderText({
      # After each click, save the results of the radio buttons.
      if ((input$Click.Counter_4>0)&(input$Click.Counter_4>!nrow(Qlist_4)))
        try(results_4[input$Click.Counter_4] <<- input$survey_4)
        # try is used because there is a brief moment in which
        # the if condition is true but input$survey = NULL

      # If the user has clicked through all of the survey questions
      # then R saves the results to the survey file.
      if (input$Click.Counter_4==nrow(Qlist_4)+1) {
      #   if (file.exists("./survey.results_4.Rdata")) {
        if (file.exists(paste('./results_files/', input$participants, 'res_4.RData', sep = ''))) {

            load(file=paste('./results_files/', input$participants, 'res_4.RData', sep = ''))
          #   load(file="./survey.results_4.Rdata")

            rn <- rownames(presults_4)
        }

        if (!file.exists(paste('./results_files/', input$participants, 'res_4.RData', sep = ''))) {
      #   if (!file.exists("./survey.results_4.Rdata")) {
            presults_4 <- rn <- NULL
        }

        rn <- c(rn,input$participants)
        presults_4 <- rbind(presults_4, results_4)
        rownames(presults_4) <- rn
        save(presults_4, file=paste('./results_files/', input$participants, 'res_4.RData', sep = ''))
      #   save(presults_4, file="./survey.results_4.Rdata")

      drop_upload(paste('./results_files/', input$participants, 'res_4.RData', sep = ''), dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)



        # Automatic grading of answers
        grade_4 <- sum(as.numeric(Alist_4[,2] == presults_4[input$participants, 1:nrow(Qlist_4)]) * pt)
        names(grade_4) <- paste(input$participants, '_4', sep='')


         write.csv(grade_4, paste('./', input$participants, '_4.csv', sep=''), row.names = TRUE, quote = TRUE, fileEncoding = 'UTF-8')
         drop_upload(paste('./', input$participants, '_4.csv', sep=''), dest = '/PhD/Misc/SurveyTool/Survey/Server_files', dtoken = token)

          plot_table <- loadData()
          saveRDS(plot_table, file = './plot_table.RDS')

          drop_upload('./plot_table.RDS', dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)

      }
      # Because there has to be a UI object to call this function I set up render text that distplays the content of this funciton.
      ""
    })

    #
    # The option list is a reative list of elements that updates itself when the click counter is advanced.
    option.list_4 <- reactive({
      qlist_4 <- Qlist_4[input$Click.Counter_4,3:ncol(Qlist_4)]
      # Remove items from the qlist if the option is empty.
      # Also, convert the option list to matrix.
      as.matrix(qlist_4[qlist_4!=""])
    })

    # This function show the question number (Q:)
    # Followed by the question text.
    output$question_4 <- renderText({
      paste0(
        "Q", input$Click.Counter_4,": ",
        Qlist_4[input$Click.Counter_4,2]
      )
    })

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# --------------------------------- Quiz 5 ------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

    # There could be a way to automate the quiz selection and tab generation as a function of the length of Qlist, but no time or interest for it at this point

      # Create an empty vector to hold survey results
      drop_get('/phd/misc/surveytool/survey/plot_table.RDS', dtoken = token, overwrite = TRUE)
      results_5 <<- rep("", nrow(Qlist_5))
      grade_5 <<- 0
      # Empty table to store results for plotOutput

      # Name each element of the vector based on the
      # second column of the Qlist
      names(results_5)  <<- Qlist_5[,2]

      # Hit counter
      output$counter_5 <-
        renderText({
          if (!file.exists("./counter_5.Rdata")) counter_5 <- 0
          if (file.exists("./counter_5.Rdata")) load(file="./counter_5.Rdata")
          counter_5 <- counter_5 <<- counter_5 + 1

          save(counter_5, file="./counter_5.Rdata")
          paste0("Hits: ", counter_5)
        })


      # This renderUI function holds the primary actions of the
      # survey area.
      output$MainAction_5 <- renderUI( {
        dynamicUi_5()
      })

      # Dynamic UI is the interface which changes as the survey
      # progresses.
      dynamicUi_5 <- reactive({
        # Initially it shows a welcome message.
        if (input$Click.Counter_5==0)
          return(
            list(
            h5('Ce premier quiz vise à tester vos connaissances générales sur Québec Océan!'),
            h5('Mise en garde :'),
            h5('N\'essayez pas de faire un retour vers l\'arrière, vous devrez tout recommencer!')
            )
          )

        # Once the next button has been clicked once we see each question
        # of the survey.
        if (input$Click.Counter_5>0 & input$Click.Counter_5<=nrow(Qlist_5)) {
          return(
            list(
              h5(textOutput("question_5")),
              radioButtons("survey_5", "Veuillez sélectionner :", option.list_5())
              )
            )
        }

        # Finally we see results of the survey as well as a
        # download button.
        if (input$Click.Counter_5>nrow(Qlist_5)) {
          return(
            # list(
              h4("Merci pour votre participation!")
            #   )
            )
        }
      })

      # This reactive function is concerned primarily with
      # saving the results of the survey for this individual.
      output$save.results_5 <- renderText({
        # After each click, save the results of the radio buttons.
        if ((input$Click.Counter_5>0)&(input$Click.Counter_5>!nrow(Qlist_5)))
          try(results_5[input$Click.Counter_5] <<- input$survey_5)
          # try is used because there is a brief moment in which
          # the if condition is true but input$survey = NULL

        # If the user has clicked through all of the survey questions
        # then R saves the results to the survey file.
        if (input$Click.Counter_5==nrow(Qlist_5)+1) {
        #   if (file.exists("./survey.results_5.Rdata")) {
          if (file.exists(paste('./results_files/', input$participants, 'res_5.RData', sep = ''))) {

              load(file=paste('./results_files/', input$participants, 'res_5.RData', sep = ''))
            #   load(file="./survey.results_5.Rdata")

              rn <- rownames(presults_5)
          }

          if (!file.exists(paste('./results_files/', input$participants, 'res_5.RData', sep = ''))) {
        #   if (!file.exists("./survey.results_5.Rdata")) {
              presults_5 <- rn <- NULL
          }

          rn <- c(rn,input$participants)
          presults_5 <- rbind(presults_5, results_5)
          rownames(presults_5) <- rn
          save(presults_5, file=paste('./results_files/', input$participants, 'res_5.RData', sep = ''))
        #   save(presults_5, file="./survey.results_5.Rdata")

        drop_upload(paste('./results_files/', input$participants, 'res_5.RData', sep = ''), dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)



          # Automatic grading of answers
          grade_5 <- sum(as.numeric(Alist_5[,2] == presults_5[input$participants, 1:nrow(Qlist_5)]) * pt)
          names(grade_5) <- paste(input$participants, '_5', sep='')


           write.csv(grade_5, paste('./', input$participants, '_5.csv', sep=''), row.names = TRUE, quote = TRUE, fileEncoding = 'UTF-8')
           drop_upload(paste('./', input$participants, '_5.csv', sep=''), dest = '/PhD/Misc/SurveyTool/Survey/Server_files', dtoken = token)

            plot_table <- loadData()
            saveRDS(plot_table, file = './plot_table.RDS')

            drop_upload('./plot_table.RDS', dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)

        }
        # Because there has to be a UI object to call this function I set up render text that distplays the content of this funciton.
        ""
      })

      #
      # The option list is a reative list of elements that updates itself when the click counter is advanced.
      option.list_5 <- reactive({
        qlist_5 <- Qlist_5[input$Click.Counter_5,3:ncol(Qlist_5)]
        # Remove items from the qlist if the option is empty.
        # Also, convert the option list to matrix.
        as.matrix(qlist_5[qlist_5!=""])
      })

      # This function show the question number (Q:)
      # Followed by the question text.
      output$question_5 <- renderText({
        paste0(
          "Q", input$Click.Counter_5,": ",
          Qlist_5[input$Click.Counter_5,2]
        )
      })

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# --------------------------------- Quiz 6 ------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

  # There could be a way to automate the quiz selection and tab generation as a function of the length of Qlist, but no time or interest for it at this point

    # Create an empty vector to hold survey results
    drop_get('/phd/misc/surveytool/survey/plot_table.RDS', dtoken = token, overwrite = TRUE)
    results_6 <<- rep("", nrow(Qlist_6))
    grade_6 <<- 0
    # Empty table to store results for plotOutput

    # Name each element of the vector based on the
    # second column of the Qlist
    names(results_6)  <<- Qlist_6[,2]

    # Hit counter
    output$counter_6 <-
      renderText({
        if (!file.exists("./counter_6.Rdata")) counter_6 <- 0
        if (file.exists("./counter_6.Rdata")) load(file="./counter_6.Rdata")
        counter_6 <- counter_6 <<- counter_6 + 1

        save(counter_6, file="./counter_6.Rdata")
        paste0("Hits: ", counter_6)
      })


    # This renderUI function holds the primary actions of the
    # survey area.
    output$MainAction_6 <- renderUI( {
      dynamicUi_6()
    })

    # Dynamic UI is the interface which changes as the survey
    # progresses.
    dynamicUi_6 <- reactive({
      # Initially it shows a welcome message.
      if (input$Click.Counter_6==0)
        return(
          list(
          h5('Ce premier quiz vise à tester vos connaissances générales sur Québec Océan!'),
          h5('Mise en garde :'),
          h5('N\'essayez pas de faire un retour vers l\'arrière, vous devrez tout recommencer!')
          )
        )

      # Once the next button has been clicked once we see each question
      # of the survey.
      if (input$Click.Counter_6>0 & input$Click.Counter_6<=nrow(Qlist_6)) {
        return(
          list(
            h5(textOutput("question_6")),
            radioButtons("survey_6", "Veuillez sélectionner :", option.list_6())
            )
          )
      }

      # Finally we see results of the survey as well as a
      # download button.
      if (input$Click.Counter_6>nrow(Qlist_6)) {
        return(
          # list(
            h4("Merci pour votre participation!")
          #   )
          )
      }
    })

    # This reactive function is concerned primarily with
    # saving the results of the survey for this individual.
    output$save.results_6 <- renderText({
      # After each click, save the results of the radio buttons.
      if ((input$Click.Counter_6>0)&(input$Click.Counter_6>!nrow(Qlist_6)))
        try(results_6[input$Click.Counter_6] <<- input$survey_6)
        # try is used because there is a brief moment in which
        # the if condition is true but input$survey = NULL

      # If the user has clicked through all of the survey questions
      # then R saves the results to the survey file.
      if (input$Click.Counter_6==nrow(Qlist_6)+1) {
      #   if (file.exists("./survey.results_6.Rdata")) {
        if (file.exists(paste('./results_files/', input$participants, 'res_6.RData', sep = ''))) {

            load(file=paste('./results_files/', input$participants, 'res_6.RData', sep = ''))
          #   load(file="./survey.results_6.Rdata")

            rn <- rownames(presults_6)
        }

        if (!file.exists(paste('./results_files/', input$participants, 'res_6.RData', sep = ''))) {
      #   if (!file.exists("./survey.results_6.Rdata")) {
            presults_6 <- rn <- NULL
        }

        rn <- c(rn,input$participants)
        presults_6 <- rbind(presults_6, results_6)
        rownames(presults_6) <- rn
        save(presults_6, file=paste('./results_files/', input$participants, 'res_6.RData', sep = ''))
      #   save(presults_6, file="./survey.results_6.Rdata")

      drop_upload(paste('./results_files/', input$participants, 'res_6.RData', sep = ''), dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)



        # Automatic grading of answers
        grade_6 <- sum(as.numeric(Alist_6[,2] == presults_6[input$participants, 1:nrow(Qlist_6)]) * pt)
        names(grade_6) <- paste(input$participants, '_6', sep='')


         write.csv(grade_6, paste('./', input$participants, '_6.csv', sep=''), row.names = TRUE, quote = TRUE, fileEncoding = 'UTF-8')
         drop_upload(paste('./', input$participants, '_6.csv', sep=''), dest = '/PhD/Misc/SurveyTool/Survey/Server_files', dtoken = token)

          plot_table <- loadData()
          saveRDS(plot_table, file = './plot_table.RDS')

          drop_upload('./plot_table.RDS', dest = '/PhD/Misc/SurveyTool/Survey', dtoken = token)

      }
      # Because there has to be a UI object to call this function I set up render text that distplays the content of this funciton.
      ""
    })

    #
    # The option list is a reative list of elements that updates itself when the click counter is advanced.
    option.list_6 <- reactive({
      qlist_6 <- Qlist_6[input$Click.Counter_6,3:ncol(Qlist_6)]
      # Remove items from the qlist if the option is empty.
      # Also, convert the option list to matrix.
      as.matrix(qlist_6[qlist_6!=""])
    })

    # This function show the question number (Q:)
    # Followed by the question text.
    output$question_6 <- renderText({
      paste0(
        "Q", input$Click.Counter_6,": ",
        Qlist_6[input$Click.Counter_6,2]
      )
    })

    # --------------------------------------------------------------------
    # --------------------------------------------------------------------
    # ------------------------------ Results -----------------------------
    # --------------------------------------------------------------------
    # --------------------------------------------------------------------

    # Output results in new tab for simultaneous visualization of graded results

    # reactive file reader that checks on updates made to the file and reloads it if necessary
    plot_table2 <- reactiveFileReader(intervalMillis = 5000, session = NULL, './plot_table.RDS', readRDS)

    output$results <- renderPlot({
        max_pt <- 0
        for(i in 1:length(Qlist)) {
            max_pt <- (max_pt + nrow(Qlist[[i]]))
        }
        max_pt <- max_pt * pt

        op <- par(mar = c(10,4,4,2) + 0.1)
        barplot(plot_table2()[,'Total'], ylim = c(0, max_pt), cex.axis = 1.25, cex.names = 1.25, names.arg = plot_table2()[,'name'], las = 3)
        par(op) ## reset
    })


})
