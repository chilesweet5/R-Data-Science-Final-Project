# R script code for Final Project

library(rvest)
library(httr)
library(tidyverse)
library(stringr)


#store wiki url into variable
url <- ('https://en.wikipedia.org/wiki/Template:COVID-19_testing_by_country')

#store response from wiki website using GET function  
response <- GET(url)

#calling response
response

#reading html from url
root_node <- read_html(url)

#extracts html specific to table
table_node <- html_node(root_node, "table")

#stores wiki table data frame into variable
df <- html_table(table_node)

#using pipe operator and functions to rename some variables and remove "Ref" column
named_df <- df %>% 
  rename(Date = "Date[a]",
         Units = "Units[b]",
         Country_Region = "Country or region",
         Cases = "Confirmed(cases)")%>% 
  select(everything(),-starts_with("Ref")) 

#replacing any blank or spaced cells with NA
named_df[named_df == "" | named_df == " "] <- NA

#Export data frame to a .csv 
covid_data <- write.csv(named_df, "covid.csv", row.names = FALSE)

#obtain and store subset of data for country / region and confirmed cases column
subset_df <- named_df[ , c("Country_Region", "Cases") ]

#removing last row with unnecessary
named_df <- named_df[-173,]

#checking changes from previous code above
tail(named_df)

#View subset data
View(subset_df)

#Removing commas from data set and replacing them with no space 
named_df$Cases <- gsub(",", "", named_df$Cases)

#Converting characters into numeric values 
named_df$Cases <- as.numeric(named_df$Cases)

#Removing commas from data set and replacing them with no space 
named_df$Tested <- gsub(",", "", named_df$Tested)

named_df$Tested <- as.numeric(named_df$Tested)

#storing total positive cases
positve_case <- sum(named_df$Cases)

#storing total tested
tested_sum <- sum(named_df$Tested)

#Worldwide positive tested covid ratio percentage
country_positive_ratio <- (positve_case / tested_sum) * 100

#storing and calling reported countries
( country_col <- sort(named_df$Country_Region, decreasing = F) )

#Using regular expressions to find countries with United  
str_match(named_df, "United.+")

#Picking two different subsets of data and calling them
( subset_df2 <- named_df[4, 1:7] )

( subset_df3 <- named_df[140, 1:7] )


#Using conditional statements to print which country had more cases 
if (subset_df2$Cases > subset_df3$Cases)  {
  print('Andorra had more cases than San Marino')
} else {
  print('San Marino had more cases than Andorra')
}


#Only printing T or F of each conuntry where the ratio is less than threshold
#Not sure how to extract
( subset_df4 <- named_df$`Confirmed /population,%` < 0.5)





