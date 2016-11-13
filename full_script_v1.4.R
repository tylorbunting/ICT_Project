#make sure to load the appropriate packages 
library(tm) #this package is for text mining
library(wordcloud) #this package is specifically for word clouds
library(ggplot2)


#############The below code is needed to prepare both skills and job market analysis
#############

#### Make sure to have the 'twoThousandJobs.csv' file in your project directory. This is the source dataset that we import into the working environment using the below code
df_twoThousandJobs <- read.csv("twoThousandJobs.csv", stringsAsFactors=FALSE)

# clean the date column so that it can be represented as a DATE. This will enable R to interpret it for time relevant analysis
df_twoThousandJobs$Date <- sub("categorized-","",df_twoThousandJobs$Date)
df_twoThousandJobs$Date <- as.Date(df_twoThousandJobs$Date)

# Subsetting the Jobs by there classifications e.g. Developer, Business Analyst and Consultant
df_developerJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Developer")
#df_businessAnalystJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Business Analysts")
#df_consultantJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Consultants")
df_architectsJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Architects")
#df_administrationJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Administration")
df_databaseJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Database Development")
df_engineeringJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Engineering")
#df_helpDeskJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Help Desk and Support")
df_securityJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Security")
#df_managementJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Management")
df_telecomJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Telecommunications")
df_testingJobs <- subset(df_twoThousandJobs, df_twoThousandJobs$Classification == " Testing and Quality")

#import time series specific dataset and clean it
df_timeSeriesJobs <- read.csv("timeSeriesJobs.csv", stringsAsFactors=FALSE)
df_timeSeriesJobs$Date <- as.Date(df_timeSeriesJobs$Date)
df_timeSeriesJobs$Classification <- as.factor(df_timeSeriesJobs$Classification)

#make frequency timeSeriesJobs data frame and then the timeSeriesJobs xts data type for plotting
freq_timeSeriesJobs <- df_timeSeriesJobs[,2:3]
freq_timeSeriesJobs$Date <- sub("........", "20", freq_timeSeriesJobs$Date)
freq_timeSeriesJobs <- data.frame(table(freq_timeSeriesJobs$Date, freq_timeSeriesJobs$Classification))
colnames(freq_timeSeriesJobs) <- c("Date", "Classification", "Frequency")

# Subsetting the Jobs by there classifications (e.g. Developer, Business Analyst and Consultant) for job freqency with dates data.frames
freq_developerJobs <- subset(freq_timeSeriesJobs, freq_timeSeriesJobs$Classification == "Developer")
freq_architectsJobs <- subset(freq_timeSeriesJobs, freq_timeSeriesJobs$Classification == "Architects")
freq_databaseJobs <- subset(freq_timeSeriesJobs, freq_timeSeriesJobs$Classification == "Database Development")
freq_engineeringJobs <- subset(freq_timeSeriesJobs, freq_timeSeriesJobs$Classification == "Engineering")
freq_securityJobs <- subset(freq_timeSeriesJobs, freq_timeSeriesJobs$Classification == "Security")
freq_telecomJobs <- subset(freq_timeSeriesJobs, freq_timeSeriesJobs$Classification == "Telecommunications")
freq_testingJobs <- subset(freq_timeSeriesJobs, freq_timeSeriesJobs$Classification == "Testing and Quality")




#################### Running the code below will generate a mad time series plot
freq_x <- freq_timeSeriesJobs
ggplot(data = freq_x, aes(x=freq_x$Date, y=freq_x$Frequency, group = freq_x$Classification)) + geom_line(aes(color=freq_x$Classification))




#############Running the below code tells us what skills relate to what jobs

#Make sure to change the dataframsource that you wish to perform the skills analysis on e.g. df_developerJobs for Developer Classification
df_source <- DataframeSource(df_testingJobs)
df_corpus <- VCorpus(df_source)
clean_corpus <- function(corpus) {
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeWords, c(stopwords("en"), "job", "description", "descriptionduties",
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
                                          "department"))
  return(corpus)}
df_corpus <- clean_corpus(df_corpus)

#A Term Document matrix can be used for multiple text mining functions
tdm_JobandSkills <- TermDocumentMatrix(df_corpus)
m_JobandSkills <- as.matrix(tdm_JobandSkills)
term_freq_JobandSkills <- rowSums(m_JobandSkills)
term_freq_JobandSkills <- sort(term_freq_JobandSkills, decreasing = TRUE)
word_freq <- data.frame(term = names(term_freq_JobandSkills), num = term_freq_JobandSkills)

#lets make a pretty wordcloud for the Developer Classification
wordcloud(word_freq$term, word_freq$num, max.words = 100, colors = "red")






#####################The below code is for generating plot that displays most commonly occuring classification
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
  df_testingJobs)

#change the appropriate characters into factors so that the "levels" can be represented
df_ITIJobs$Classification = as.factor(df_ITIJobs$Classification)
df_ITIJobs$Level = as.factor(df_ITIJobs$Level)
df_ITIJobs$JobType = as.factor(df_ITIJobs$JobType)

#plot out the most commonly occuring classifications
plot(df_ITIJobs$Classification)



