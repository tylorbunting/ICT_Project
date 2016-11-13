





library(shinydashboard) # structuring UI
library(shiny)          # base shiny package
library(tm)             # text mining
library(wordcloud)      # making awesome wordclouds
library(memoise)        # memoization package
library(RColorBrewer)   # making awesome plots
library(ggplot2)        # also for making awesome plots
library(plyr)           # rbind(ing) lists of dataframes for the check box, time series plot

###################################################################################################################################

#### Make sure to have the 'twoThousandJobs.csv' file in your project directory. This is the source dataset that we import into the working environment using the below code

df_twoThousandJobs <-
  read.csv("twoThousandJobs.csv",
           stringsAsFactors = FALSE)

# clean the date column so that it can be represented as a DATE. This will enable R to interpret it for time relevant analysis

df_twoThousandJobs$Date <-
  sub("categorized-", "", df_twoThousandJobs$Date)
df_twoThousandJobs$Date <- as.Date(df_twoThousandJobs$Date)

# Subsetting the Jobs by there classifications e.g. Developer, Business Analyst and Consultant
df_developerJobs <-
  subset(df_twoThousandJobs,
         df_twoThousandJobs$Classification == " Developer")
#df_businessAnalystJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Business Analysts")
#df_consultantJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Consultants")
df_architectsJobs <-
  subset(df_twoThousandJobs,
         df_twoThousandJobs$Classification == " Architects")
#df_administrationJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Administration")
df_databaseJobs <-
  subset(df_twoThousandJobs,
         df_twoThousandJobs$Classification == " Database Development")
df_engineeringJobs <-
  subset(df_twoThousandJobs,
         df_twoThousandJobs$Classification == " Engineering")
#df_helpDeskJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Help Desk and Support")
df_securityJobs <-
  subset(df_twoThousandJobs,
         df_twoThousandJobs$Classification == " Security")
#df_managementJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Management")
df_telecomJobs <-
  subset(df_twoThousandJobs,
         df_twoThousandJobs$Classification == " Telecommunications")
df_testingJobs <-
  subset(df_twoThousandJobs,
         df_twoThousandJobs$Classification == " Testing and Quality")



######################################################################

###The below code is used to import data for time series plot

#import time series specific dataset and clean it

df_timeSeriesJobs <-
  read.csv("timeSeriesJobs.csv",
           stringsAsFactors = FALSE)
df_timeSeriesJobs$Date <- as.Date(df_timeSeriesJobs$Date)
df_timeSeriesJobs$Classification <-
  as.factor(df_timeSeriesJobs$Classification)

#make frequency timeSeriesJobs data frame and then the timeSeriesJobs xts data type for plotting

freq_timeSeriesJobs <- df_timeSeriesJobs[, 2:3]
freq_timeSeriesJobs$Date <- as.character(freq_timeSeriesJobs$Date)
freq_timeSeriesJobs$Date <-
  print(sub("........", "20", freq_timeSeriesJobs$Date))
freq_timeSeriesJobs <-
  print(data.frame(table(
    freq_timeSeriesJobs$Date,
    freq_timeSeriesJobs$Classification
  )))
colnames(freq_timeSeriesJobs) <-
  c("Date", "Classification", "Frequency")


# Subsetting the Jobs by there classifications (e.g. Developer, Business Analyst and Consultant) for job freqency with dates data.frames

freq_developerJobs <- freq_timeSeriesJobs[freq_timeSeriesJobs$Classification == "Developer",]
freq_architectsJobs <- freq_timeSeriesJobs[freq_timeSeriesJobs$Classification == "Architects",]
freq_databaseJobs <- freq_timeSeriesJobs[freq_timeSeriesJobs$Classification == "Database Development",]
freq_engineeringJobs <- freq_timeSeriesJobs[freq_timeSeriesJobs$Classification == "Engineering",]
freq_securityJobs <- freq_timeSeriesJobs[freq_timeSeriesJobs$Classification == "Security",]
freq_telecomJobs <- freq_timeSeriesJobs[freq_timeSeriesJobs$Classification == "Telecommunications",]
freq_testingJobs <- freq_timeSeriesJobs[freq_timeSeriesJobs$Classification == "Testing and Quality",]


####################################################################################

########The below code is for generating plot that displays most commonly occuring classification
########This shows us job markets in demand

#get only IT categories by binding all of the already subsetted classifications

df_ITIJobs <- rbind(
  #df_administrationJobs,
  df_architectsJobs,
  #df_businessAnalystJobs,
  #df_consultantJobs,
  df_databaseJobs,
  df_developerJobs,
  df_engineeringJobs,
  #df_helpDeskJobs,
  #df_managementJobs,
  df_securityJobs,
  df_telecomJobs,
  df_testingJobs
)

#The below code makes the list that is needed for the word cloud communication between UI, Server and Global .R files

ls_ITIJobs <- list(
  "df_ITIJobs" = df_ITIJobs,
  #df_administrationJobs,
  "df_architectsJobs" = df_architectsJobs,
  #df_businessAnalystJobs,
  #df_consultantJobs,
  "df_databaseJobs" = df_databaseJobs,
  "df_developerJobs" = df_developerJobs,
  "df_engineeringJobs" = df_engineeringJobs,
  #df_helpDeskJobs,
  #df_managementJobs,
  "df_securityJobs" = df_securityJobs,
  "df_telecomJobs" = df_telecomJobs,
  "df_testingJobs" = df_testingJobs
)

#change the appropriate characters into factors so that the "levels" can be represented

df_ITIJobs$Classification = as.factor(df_ITIJobs$Classification)
df_ITIJobs$Level = as.factor(df_ITIJobs$Level)
df_ITIJobs$JobType = as.factor(df_ITIJobs$JobType)




###########################################################################################################################

#### The below code is used to generate the word cloud

# List of valid classifications to select from

classifications <- list(
  "Information Technology Industry Jobs" = "df_ITIJobs",
  "- IT Architect Jobs" = "df_architectsJobs",
  "- Database Developer Jobs" = "df_databaseJobs",
  "- Software Developer Jobs" = "df_developerJobs",
  "- Network and Hardware Engineering Jobs" = "df_engineeringJobs",
  "- IT Security Jobs" = "df_securityJobs",
  "- IT Telecommunications Jobs" = "df_telecomJobs",
  "- Software Testing Jobs" = "df_testingJobs"
)

# using "memoise" to automatically cache results

getTermMatrix <- memoise(function(classification)
{
  df_source <- as.vector(ls_ITIJobs[[classification]][8])
  df_source <- VectorSource(df_source)
  df_corpus <- VCorpus(df_source)
  clean_corpus <- function(corpus)
  {
    corpus <- tm_map(corpus, content_transformer(tolower))
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, removeNumbers)
    corpus <- tm_map(corpus, stripWhitespace)
    corpus <-
      tm_map(
        corpus,
        removeWords,
        c(
          stopwords("en"),
          "job",
          "description",
          "descriptionduties",
          "australia",
          "australian",
          "including",
          "include",
          "branch",
          "applicants",
          "will",
          "with",
          "within",
          "must",
          "ensure",
          "department"
        )
      )
    return(corpus)
  }
  df_corpus <- clean_corpus(df_corpus)
  
  # The Term Document matrix is then created using the below code
  
  tdm_JobandSkills <-
    TermDocumentMatrix(df_corpus, control = list(minWordLength = 1))
  
  # The Term Document is turned into a matrix and sorted into decreasing order using the below code
  
  m_JobandSkills <- as.matrix(tdm_JobandSkills)
  term_freq_JobandSkills <- rowSums(m_JobandSkills)
  term_freq_JobandSkills <-
    sort(term_freq_JobandSkills, decreasing = TRUE)
  
  # word_freq <- data.frame(term = names(term_freq_JobandSkills), num = term_freq_JobandSkills)
  
  
})