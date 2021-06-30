#########################################################################
#This file explores the grades_collection of sample_training database#
#########################################################################

library(mongolite)

# This is the connection_string. You can get the exact url from your mongodb cluster screen
connection_string = 'mongodb+srv://m001-student:m001-mongodb-basics@sandbox.qurli.mongodb.net/myFirstDatabase'

# get the data by specifying the database name, collection and connection url
grades_collection = mongo(collection="grades", db="sample_training", url=connection_string)

#scores by all students of class_id 7 with statistics of max score, min score etc.
class_score_allstudents = grades_collection$aggregate('[{"$match":{"class_id":7}},{"$unwind":{"path": "$scores"}},{"$project":{"scores.score":1,"_id":0,"scores.type":1,"class_id":1}}]')

# Get all the score values
score_values <- class_score_allstudents$scores$score

# Get basic statistics
median_class <- median(score_values)
mean_class <- mean(score_values)

# Plot box and whisker that shows all the basic statistics graphically
b<-boxplot(score_values,col="orange",main = "Overall score details of all students attending class with id '7'")
stripchart(score_values, method = "jitter", pch = 19, add = TRUE, col = "black", vertical=TRUE)

# Get the statistics on RStudio console (or the editor you are using)
b$stats

# Range of exam scores for all students in exam for class_id 7
student_score_exam = grades_collection$aggregate('[{"$unwind":{"path": "$scores"}},{"$match":{"class_id":7,"scores.type":"exam"}}]')
print(student_score_exam)

scores_of_allstudents <- student_score_exam$scores$score

# Plot the histogram
hist(scores_of_allstudents,col="skyblue",border="black",xlab="Scores of all students of class id 7")

# To view all the data points and the min and max values, we can sort the data
sort(scores_of_allstudents)

# We can also get min and max values using R function range()
range_scores = range(scores_of_allstudents)

print(range_scores)

