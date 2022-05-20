library(rvest)
library(httr)
library(tidyverse)

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
         Country_Region = "Country or region") %>% 
  select(everything(),-starts_with("Ref")) 

#replacing any blank or spaced cells with NA
named_df[named_df == "" | named_df == " "] <- NA

#Export data frame to a .csv 
covid_data <- write.csv(named_df, "covid.csv", row.names = FALSE)

#obtain and store subset of data for country / region and confirmed cases column
subset_df <- named_df[ , c("Country_Region", "Confirmed(cases)") ]

#View subset data
View(subset_df)

confirmed <- named_df$Confirmed(cases)

country_positive_ratio <- "Country_Region" / "Confirmed(cases)"
