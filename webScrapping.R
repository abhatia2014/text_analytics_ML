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



# Webscrapping using R ----------------------------------------------------

#Here'll we'll use R's new package rvest to extract addresses from web pages
#and ggmap to geocode those addresses

#install the leaflet package from github

devtools::install_github("rstudio/leaflet")

library(dplyr)
library(rvest)
library(ggmap)
library(RColorBrewer)

#we'll look for the addresses of Ithica wineries and breweries
# http://www.visitithaca.com/attractions/wineries.html

url=read_html("http://www.visitithaca.com/attractions/wineries.html")

#find the exact pieces of the website that you need

#The function html_nodes pulls out the entire node from the DOM and then the function html_text allows us to limit to the text within the node. 
selector_name=".indSearchListingTitle"
#getting the names of all wineries from the page

frames=html_nodes(x=url,css=selector_name)%>%
  html_text()

frames

#now extract the addresses

selector_address=".indSearchListingMetaContainer div:nth-child(2) div:nth-child(1) .indMetaInfoWrapper"

faddresses=html_nodes(url,selector_address)%>%
  html_text()

head(faddresses)

#let's do a little of string cleanup

to_remove=paste(c("\n","^\\s+|\\s+$"),collapse = "|")
to_remove
faddresses=gsub(to_remove,"",faddresses)

#now use the ggmap to geocode the addresses
#first we get the lat, long of all the addresses

geocodes=geocode(faddresses,output = "latlona")

#geocode text cleanup

head(geocodes)

full=mutate(geocodes,names=f)