#########################################################################
#This file explores the companies_collection of sample_training database#
#########################################################################

# import mongolite
library(mongolite)
library(ggplot2)

# Get the collection
companies_collection = mongo(collection="companies", db="sample_training", url=connection_string)

# Year-wise increase/decrease in consulting companies after 2003
consulting_companies_year_wise = companies_collection$aggregate('[
{"$match":{"category_code":"consulting","founded_year":{"$gt":2003}}},
{"$group":{"_id":"$founded_year", "Count": {"$sum":1}}},
{"$sort":{"_id": 1}}
]')

# Create dataframe to use ggplot
df<-as.data.frame(consulting_companies_year_wise)

ggplot(df,aes(x=`_id`,y=Count))+
geom_line(size=2,color="blue")+
geom_point(size=4,color="red")+
ylab("Number of consulting companies")+ggtitle("Year-wise (2004 onwards) companies founded in the category 'consulting'")+xlab("Year")

# View all the locations of the company 'Facebook'

# Get the location array objects
fb_locs = companies_collection$aggregate('[{"$match":{"name":"Facebook"}},{"$unwind":{"path":"$offices"}}]')

# Get individual fields from each array object
loc_long <- fb_locs$offices$longitude
loc_lat <- fb_locs$offices$latitude
loc_city <- fb_locs$offices$city

# Plot the map
install.packages("maps")
library(maps)

map("world", fill=TRUE, col="white", bg="lightblue", ylim=c(-60, 90), mar=c(0,0,0,0))
points(loc_long,loc_lat, col="red", pch=16)
text(loc_long, y = loc_lat, loc_city, pos = 4, col="red")

