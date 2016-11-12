



# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


shinyServer(function(input, output, session) {
  # The below output$classificationPlot is used for plotting the classification bar graph
  output$classificationPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    jclass    <- df_ITIJobs$Classification
    # plot out the job classifications  
    plot(jclass, col = 'darkgray', border = 'white')
  })
  
  
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  # The below output$wordcloudPlot is used for plotting the skills wordcloud
  output$wordcloudPlot <- renderPlot({
    # The below code is needed to set the word frequency limit
    x <- terms()
    # Code needs to be added that edits the 'max.words' output
    wordcloud_rep(
      names(x),
      x,
      scale = c(5, 0.5),
      min.freq = input$freq,
      max.words = input$max,
      colors = brewer.pal(8, "Dark2")
    )
  })
  
  
  # The below output$rawDataset is used for displaying the raw data used in this analysis
  output$rawDataset <- renderPrint({
    rawDisplay <- df_ITIJobs[0:100, c("Classification", "Date")]
    print(rawDisplay)
    
  })
  
  
  
})
