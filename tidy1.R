# Author: Vishi Cline
# Created Date:  10/21/2016
# Description:  R code to tidy the data for the gross domestic product 

#read the gdp.csv file into gdp dataframe
gdp<-read.csv("gdp.csv", stringsAsFactors = FALSE, header=FALSE)

#analyze the columns and data types for the columns
str(gdp)

#store the raw data into gdpraw
gdpraw<-gdp

#retrieve data for analyzing the raw data for the file
#get the first 15 rows, and the last 100 rows
head(gdp,15)
tail(gdp,100)

#Based on the data, it is evident that the data starts at row6 so exclude the first 6 rows
gdpdata<-gdp[6:236,]

#Rename the column variables
names(gdpdata)<-c("CountryShortCode","ranking","Del3","Country","GDP","SpecialNotes","Del7","Del8","Del9","Del10")

#Delete the empty columns
gdpdata$Del3<-NULL
gdpdata$Del7<-NULL
gdpdata$Del8<-NULL
gdpdata$Del9<-NULL
gdpdata$Del10<-NULL

#confirm that the Del columns were deleted and other columns renamed
head(gdpdata)
str(gdpdata)

#################################################################
#Data COnversions
################################################################
#Convert the data type for GDP to numeric and remove all formatting
gdpdata$GDP<-as.numeric(gsub(",","",gdpdata$GDP))
#Convert the data type for ranking to integer
gdpdata$ranking<-as.integer(gdpdata$ranking)
str(gdpdata)

#for any blank values, replace with NA
gdpdata[gdpdata==""] <- NA

#get a total count of all NA variables for GDP, CountryShortCode and ranking
count(is.na(gdpdata$GDP))
count(is.na(gdpdata$CountryShortCode))
count(is.na(gdpdata$ranking))

#############################################################################
#remove data that does not pertain to country and place in a separate dataset 
#############################################################################
#Following contains income data for the countries
incomes <- gdpdata[grep("income",gdpdata$Country,ignore.case=T),]

#Following contains world related data
world <- gdpdata[grep("world",gdpdata$Country,ignore.case=T),]

#Following rows pertain to regions as opposed to countries
subtotals<-gdpdata[grep("eap|eca|lac|mna|sas|ssa|emu",gdpdata$CountryShortCode,ignore.case=T),]

#Remove the data pertaining to incomes, the world and the subtotals for regions from country dataset
gdpdata<-subset(gdpdata, !(gdpdata$Country %in% incomes$Country))
gdpdata<-subset(gdpdata, !(gdpdata$Country %in% world$Country))
gdpdata<-subset(gdpdata, !(gdpdata$Country %in% subtotals$Country))

#remove all the NA's for CountryShortCode, GDP, and ranking from gdpdata
gdpdata <- gdpdata[!is.na(gdpdata$CountryShortCode),]
gdpdata <- gdpdata[!is.na(gdpdata$GDP),]
gdpdata <- gdpdata[!is.na(gdpdata$ranking),]

#Upate the special notes to contain more meaningful information, rather than abbreviations
gdpdata$SpecialNotes<-sapply(gdpdata$SpecialNotes,switch,
                a = "Includes Former Spanish Sahara",
                b = "Excludes south Sudan", 
                c = "Covers mainland Tanzania only", 
                d = "Data are for the area controlled by the government of Repulic of Cyprus",
                e = "Excludes Abkhazia and South Ossetia",
                f = "Excludes Transnistria")


#Confirm the count of NA's
count(is.na(gdpdata$GDP))
count(is.na(gdpdata$CountryShortCode))
count(is.na(gdpdata$ranking))