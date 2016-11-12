




# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# the 'dashboardPage()' function specifies that we are using dashboard strucutre
dashboardPage(
  dashboardHeader(title = "Job Market Analysis"),
  # sidebarMenu, menuItems are linked with the tabItems,tabItem code
  dashboardSidebar(
    sidebarMenu(
      menuItem("Main", tabName = "main"),
      menuItem("Geographical", tabName = "geo"),
      menuItem("Word Cloud", tabName = "cloud"),
      menuItem("Job Markets", tabName = "jobs"),
      menuItem("Raw Data", tabName = "raw")
    )
  ),
  
  
  dashboardBody(# the below code corresponds to the sidebarMenue, menuItem code
    tabItems(
      # this tabItem 'main' will display the basic must have requirements
      # which includes 'Displaying Job markets showing growth'
      # as well as 'Skills that will be in demand'
      tabItem("main"
              ,fluidRow(column(
                8,
                box(
                  width = 12,
                  title = "Frequency of Mentioned Classifications",
                  plotOutput("classificationPlot", width = "100%", height = 400)
                )
              )
              #,
              # column(
              #   4,
              #   box(
              #     width = 12,
              #     title = "Skills in Demand",
              #     plotOutput("wordcloudPlot", width = "100%", height = 400)
              #   )
              # )),
              #
              # fluidRow(
              #   column(8),
              #
              #   column(4,
              #          sidebarPanel( width = 12,
              #                        selectInput("selection", "Choose a Classification:",
              #                                    choices = classifications),
              #                        actionButton("update", "Update"),
              #                        hr(),
              #                        sliderInput("freq",
              #                                    "Minimum Frequency:",
              #                                    min = 1,  max = 50, value = 15),
              #                        sliderInput("max",
              #                                    "Maximum Number of Words:",
              #                                    min = 1,  max = 20,  value = 5)
              #          ))
              )
              ),
              
              # this tabItem 'geo' will display geographical information relating
              # to the data e.g. salary averages for each state
              # and most popular classification for each state
              tabItem("geo"),
              
              # this tabItem 'cloud' will display purely cloud data
              tabItem(
                "cloud",
                box(
                  width = 12,
                  title = "Skills in Demand",
                  plotOutput("wordcloudPlot", width = "100%", height = 400)
                ),
                
                fluidRow(
                  column(
                    12,
                    sidebarPanel(
                      width = 12,
                      selectInput("selection", "Choose a Classification:",
                                  choices = classifications),
                      actionButton("update", "Update"),
                      hr(),
                      sliderInput(
                        "freq",
                        "Minimum Frequency:",
                        min = 1,
                        max = 50,
                        value = 15
                      ),
                      sliderInput(
                        "max",
                        "Maximum Number of Words:",
                        min = 1,
                        max = 20,
                        value = 5
                      )
                    )
                  ))
              ),
              
              # this tabItem 'jobs' will display purely job classification data
              tabItem("jobs"),
              
              # this tabItem 'raw' will display the original raw dataset
              # that was subsetted for the Job Market analysis
              tabItem("raw",
                      box(
                        width = 12,
                        title = "Raw Dataset",
                        verbatimTextOutput("rawDataset")
                      ))
      ))
  )
  