# script for assignment 1 by Jakob Serlier

# Jakob Serlier
# October 23rd, 2019
# (not really my) first script

## World says hi back.
var <- "Hello World!"
var
print(var)
print(paste('Hello','World!'), quote= FALSE)
typeof(var)
is.character(var)
is.integer(var)

#The simple syntax stuff:
7 + 5
7 - 5
7 * 5
7 ^ 5
7 / 5 
7 %% 5
7 %/% 5

# Comparisons: 
7 > 5
# returns TRUE
7 < 5 
# returns FALSE
7 != 5
# returns TRUE

# Multiple comparisons
(5 > 7) & (6 * 7 == 42)
(5 < 7) & (6 * 7 == 42)
(5 > 7) | (6 * 7 == 42)

# Typechecking
is.numeric(7)
is.na(NA)
is.na("NA")

#so this doesn't work sadly? Returns non-boolean.. weird I should check it out later.
is.na(str("NA", quote = FALSE))

is.character(7)
is.character("7")
is.character("seven")
is.na("seven")

pi
pi * 10
pi - 3.1415926535897932384626
cos(pi/4)

?reserved

time.factor <- 12  
time.factor
time.in.years <- 2.5
time.in.years * time.factor
time.in.months <- time.in.years * time.factor
time.in.months
time.in.months <- 45

ls()
rm(time.in.months)
ls()

##vectors
students <- c("Alice", "Bob", "Chris", "Dana", "Eve")
midterm <- c(80, 90, 93, 82, 95)
print(students, quote=FALSE)
midterm

for(student in students){
  print(student)
}

student[2:5]
students[-4]
students[1:2]

final <- c(78, 84, 95, 82, 91)
final + midterm
grade_average <- (final + midterm) / 2
final_grade <- 0.6*final + 0.4*midterm








## some extra personal testing
is_even <- function(nmb) {
  return(nmb %% 2 == 0)
}
is_even(2)


## simple recursion
fibonacci <- function(x) {
  if (x < 0){
    return("Check your input")
  }
  if (x == 0){
    return(0)
  }
  if (x == 1){
    return(1)
  }
  return(fibonacci(x-1) + fibonacci(x-2))
}
fibonacci(9)


## creating a dataframe
department <- c('Heinz', 'CS', 'Tepper')
students <- c(333, 444, 555)
av_grad_date <- as.Date(c('2010-11-1','2008-3-25','2007-3-14'))

cmu.data <- data.frame(department, students, av_grad_date)
cmu.data
