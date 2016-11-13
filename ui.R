









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
      menuItem("Word Cloud", tabName = "cloud"),
      menuItem("Time Series Analysis", tabName = "freq"),
      menuItem("Geographical", tabName = "geo")
    )
  ),
  
  
  dashboardBody(# the below code corresponds to the sidebarMenue, menuItem code
    
    tabItems(
      # this tabItem 'main' will display the basic must have requirements
      # which includes 'Displaying Job markets showing growth'
      # as well as 'Skills that will be in demand'
      
      tabItem(
        "main",
        h1("Welcome - Main"),
        br(),
        fluidRow(column(
          12,
          box(
            width = 12,
            p(
              "The objective of this application is to analysis job market trends and
              present the findings in an accessible format for various users. This
              application offers simplistic functionalities to users as well as a
              framework from which future developers can build from. A Link to the
              GitHub project for this application can be found:"
            ),
            
            helpText(
              a("github.com/buntoss/ICT_Project", href = "https://github.com/buntoss/ICT_Project", colors = "white")
            )
            ,
            p(
              "An example of some of the data used for this project can be seen below."
            )
            )
          )),
        fluidRow(column(
          12,
          box(
            width = 12,
            title = "Raw Dataset",
            dataTableOutput("rawDataset")
          )
        ))
      ),
      
      # this tabItem 'cloud' will display purely cloud data
      
      tabItem(
        "cloud",
        h1("Skills by Classification - Wordcloud Analysis"),
        br(),
        box(width = 12,
            plotOutput(
              "wordcloudPlot", width = "100%", height = 400
            )),
        
        fluidRow(column(
          4,
          box(
            width = 12,
            background = "light-blue",
            title = "Wordcloud of Skills",
            p(
              "The above image displays frequently mentioned words by classification.
              The input variables can be changed to display frequently occuring words
              for all 'Information Technology Jobs' or a specific sub classification
              for that industry e.g. IT Architecture Jobs."
            )
            )
            ),
          column(
            8,
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
                max = 20,
                value = 5
              ),
              sliderInput(
                "max",
                "Maximum Number of Words:",
                min = 1,
                max = 100,
                value = 40
              )
            )
          ))
          ),
      
      # this tabItem 'jobs' will display purely job classification data
      
      tabItem(
        "freq"
        ,
        h1("Job Market Growth - Time Series Analysis"),
        br(),
        fluidRow(column(
          12,
          box(
            width = 12,
            title = "Information Technology Industry Job Postings",
            plotOutput("jobFreqPlot", width = "100%", height = 300)
          )
        )),
        fluidRow(column(
          8,
          box(
            width = 12,
            background = "light-blue",
            title = "Time Series Analysis",
            p(
              "The above plots display time series data for frequency
              of Job Postings by classification from 2007 till 2016.
              The main plot displays all Information Technology
              Industry Job Postings and the other plots diplay Job
              Postings for each sub classification."
            )
            )
            ),
          column(
            4,
            box(
              width = 12,
              title = "Network and Hardware Engineering",
              plotOutput("engiFreqPlot", width = "100%", height = 100)
            )
          )),
        fluidRow(column(
          4,
          box(
            width = 12,
            title = "Software Testing",
            plotOutput("testFreqPlot", width = "100%", height = 100)
          )
        ),
        column(
          4,
          box(
            width = 12,
            title = "Database Developer",
            plotOutput("dbasFreqPlot", width = "100%", height = 100)
          )
        ),
        column(
          4,
          box(
            width = 12,
            title = "Software Developer",
            plotOutput("devFreqPlot", width = "100%", height = 100)
          )
        )),
        
        fluidRow(column(
          4,
          box(
            width = 12,
            title = "IT Architecture",
            plotOutput("archFreqPlot", width = "100%", height = 100)
          )
        ),
        column(
          4,
          box(
            width = 12,
            title = "IT Security",
            plotOutput("secFreqPlot", width = "100%", height = 100)
          )
        ),
        column(
          4,
          box(
            width = 12,
            title = "IT Telecommunications",
            plotOutput("teleFreqPlot", width = "100%", height = 100)
          )
        ))
        
          ),
      
      
      tabItem("geo",
              h2("Future Development - to be continued")),
      # this tabItem 'raw' will display the original raw dataset
      # that was subsetted for the Job Market analysis
      
      tabItem("raw",
              fluidRow(column(
                12
              )))
        ))
)
  