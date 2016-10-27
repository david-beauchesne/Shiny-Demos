library(shiny)

# Read the survey questions for multiple quizzes
# Save questions as a list of questions for multiple quizzes
load('./Qlist.RData') # Quiz list with questions in individual matrices with col structure = c(Question number, Question, choices as multiple columns)
load('./Alist.RData') # Quiz answers with structure = structure(Qlist), col = c(Question number, Answer)
Qlist_1 <- Qlist[[1]]
Qlist_2 <- Qlist[[2]]
Qlist_3 <- Qlist[[3]]
Qlist_4 <- Qlist[[4]]

Alist_1 <- Alist[[1]]
Alist_2 <- Alist[[2]]
Alist_3 <- Alist[[3]]
Alist_4 <- Alist[[4]]

pt <- 10
nQuiz <- 4

shinyServer(function(input, output) {


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# --------------------------------- Quiz 1 ------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

    # There could be a way to automate the quiz selection and tab generation as a function of the length of Qlist, but no time or interest for it at this point

      # Create an empty vector to hold survey results
      load('./plot_table.RData')
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
              h5("Welcome to Shiny Survey Tool!"),
              h6("by Francis Smart")
            )
          )

        # Once the next button has been clicked once we see each question
        # of the survey.
        if (input$Click.Counter_1>0 & input$Click.Counter_1<=nrow(Qlist_1)) {
          return(
            list(
              h5(textOutput("question_1")),
              radioButtons("survey_1", "Please Select:", option.list_1())
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
          if (file.exists("./survey.results_1.Rdata")) {
              load(file="./survey.results_1.Rdata")
              rn <- rownames(presults_1)
          }

          if (!file.exists("./survey.results_1.Rdata")) {
              presults_1 <- rn <- NULL
          }

          rn <- c(rn,input$participants)
          presults_1 <- rbind(presults_1, results_1)
          rownames(presults_1) <- rn
          save(presults_1, file="./survey.results_1.Rdata")

          # Automatic grading of answers
          grade_1 <- sum(as.numeric(Alist_1[,2] == presults_1[input$participants, 1:nrow(Qlist_1)]) * pt)
          names(grade_1) <- input$participants

          load('./plot_table.RData')
          if(!input$participants %in% rownames(plot_table)) {
              n <- sum(!rownames(plot_table) == '')

              plot_table[n + 1, as.numeric(substring('grade_1',nchar('grade_1'),nchar('grade_1')))] <- grade_1
              rownames(plot_table)[n+1] <- input$participants
          } else {
              plot_table[input$participants, as.numeric(substring('grade_1',nchar('grade_1'),nchar('grade_1')))] <- grade_1 # too complicated, it's simply to be able to replace all _1 in text at once
          }

          plot_table[, 'Total'] <- rowsum(t(plot_table[, 1:nQuiz]), rep(1,nQuiz))
          save(plot_table, file = './plot_table.RData')
          saveRDS(plot_table, file = './plot_table.RDS')

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










    # --------------------------------------------------------------------
    # --------------------------------------------------------------------
    # ------------------------------ Results -----------------------------
    # --------------------------------------------------------------------
    # --------------------------------------------------------------------

    # Output results in new tab for simultaneous visualization of graded results

    # reactive file reader that checks on updates made to the file and reloads it if necessary
    plot_table2 <- reactiveFileReader(intervalMillis = 5000, session = NULL, './plot_table.RDS', readRDS)
    
    output$results <- renderPlot({
            barplot(plot_table2()[,'Total'])
        })


})
