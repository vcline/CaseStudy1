# Author: Vishi Cline
# Created Date:  10/21/2016
# Description:  R code to tidy the data for educational data


#read the educ.csv file into educ dataframe
educ<-read.csv("RawData//educ.csv", stringsAsFactors = FALSE, header=TRUE)

#analyze the columns and data types for the columns
str(educ)

#store the raw data into educraw
educraw<-educ

#retrieve data for analyzing the raw data for the file
#get the first 5 rows, and the last 100 rows
head(educ,5)
tail(educ,100)

#for any blank values, replace with NA
educ[educ==""] <- NA

#rename the CountryCode column to CountryShortCode and Income.Group to IncomeGroup
colnames(educ)[colnames(educ)=="CountryCode"]<- "CountryShortCode"
colnames(educ)[colnames(educ)=="Income.Group"]<- "IncomeGroup"

#get a total count of all NA variables for CountryCode and Income.Group
count(is.na(educ$CountryShortCode))
count(is.na(educ$IncomeGroup))

#remove all the NA's from IncomeGroup
educ<- educ[!is.na(educ$IncomeGroup),]


