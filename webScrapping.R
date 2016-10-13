#we'll be looking at reviews for 5 most popular romance books
#Let's try and commit once
#Part 1 - Webscrapping, Part 2- Exploratory analysis, Part 3- Machine Learning

#we'll be loading the RSelenium package 


# Load Required Libararies ------------------------------------------------

library(data.table)
library(dplyr)
library(magrittr)
library(rvest)
library(RSelenium)
url <- "https://www.goodreads.com/book/show/18619684-the-time-traveler-s-wife#other_reviews"
output.filename="GR_TimeTravelersWife.csv"

#start Selenium Server
checkForServer(update = TRUE)
path="/Users/aankurbhatia/Applications/Firefox.app"

startServer(-Dwebdriver.firefox.bin=pathtoexecutable , log = FALSE, invisible = FALSE)

remDr <- remoteDriver(browser='firefox')
remDr$checkStatus()

Sys.sleep(10)
remDr$open()
remDr$navigate(url)

