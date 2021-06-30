###########################################################################
#This file explores the inspections_collection of sample_training database#
###########################################################################

# import mongolite
library(mongolite)

# Get the collection
inspections_collection = mongo(collection="inspections", db="sample_training", url=connection_string)

# How many failed the inspection in the year 2015 vs 2016
year_failures = inspections_collection$aggregate('[{"$addFields": {"format_year":{"$year":{"$toDate":"$date"}}}},
{"$match":{"result":"Fail"}},
{"$group":{"_id":"$format_year", "Failed": {"$sum":1}}}]')


df<-as.data.frame(year_failures)

ggplot(df,aes(x=reorder(`_id`,Failed),y=Failed))+
geom_bar(stat="identity", width=0.4, color='skyblue',fill='skyblue')+
geom_text(aes(label = Failed), color = "black") +coord_flip()+xlab("Year")