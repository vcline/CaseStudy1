# Author: Vishi Cline
# Created Date:  10/21/2016
# Description:  R code for performing analysis of the code

#Merge the data based on the country shortcode.
matchingIDs<-merge(educ,gdpdata,by="CountryShortCode", all=FALSE) 
#number of machingIDs
nrow(matchingIDs)

#Sort the data frame in ascending order by GDP (so United States is last).
ascendingOrder<-matchingIDs[order(matchingIDs[,34]),]
#The 13th country in the resulting data frame
ascendingOrder[13,2]

#the average GDP rankings for the "High income: OECD" and "High income:nonOECD" groups
rankingsForOECD <- matchingIDs[which(matchingIDs$IncomeGroup=="High income: OECD"),]
mean(rankingsForOECD$ranking)
rankingsFornonOECD <- matchingIDs[which(matchingIDs$IncomeGroup=="High income: nonOECD"),]
mean(rankingsFornonOECD$ranking)

#Plot the GDP for all of the countries. Use ggplot2 to color your plot by Income Group.
g<-ggplot(ascendingOrder,aes(x=factor(ascendingOrder$IncomeGroup), y=ascendingOrder$GDP, fill=factor(ascendingOrder$IncomeGroup)))+ geom_bar(width=.5,stat="identity",
colour="black",position=position_dodge())+xlab("Income Group")+ylab("GDP")+labs(fill="Income Group")
print(g)

#######################################################################################
#Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group.
######################################################################################
#Get the number of rankings
CountOfRows<-length(ascendingOrder$ranking)
#Create a new dataframe called df, with quantile and ranking column
df<-data.frame(incomeGroup=character(0),quantile=numeric(0),ranking=numeric(0), GDP=numeric(0), stringsAsFactors = FALSE)
#Calculate the number of obervations per group, for the 5 quantile groups
ObservationsinGroups<-round(CountOfRows/5, digits=0)
#initialize grp variable
grp<-1
#populate the df data frame with the observed ranking, GDP, Income Group and the corresponding quantile group
for (i in 1:CountOfRows)
{
  
  if (i %% ObservationsinGroups==0)
  {grp<-grp+1}
  
  df[i,"quantile"]<-grp
  df[i,"ranking"]<-ascendingOrder$ranking[i]
  df[i,"GDP"]<-ascendingOrder$GDP[i]
  df[i,"incomeGroup"]<-ascendingOrder$IncomeGroup[i]
 
}

#Make a table of GDP versus Income.Group.
print(table(quantile=df$quantile, incomegroup=factor(df$incomeGroup)))


                                                                                                                                                 


