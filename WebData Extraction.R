#source
#https://github.com/ropensci/user2016-tutorial/blob/master/slides.pdf

#REST API- Representational State Transfer

#e.g. httr hello world

library(httr)

data=httr::GET("https://github.com/")

head(data,6)
c=data$cookies
rm(c)

httr::GET('https://google.com/')

#HTTP Verb and requests

#get- read- retrieve what is specified by the URL
#post- create - create resources with the given data
#put - update - update resources with the given data
#delete- delete - delete resources at the URL

#other verbs
#HEAD- identical to GET but get only headers back
#PATCH- partly modify but similar to put
#COPY- copy a resource from one URL to another
#OPTIONS- get what verbs supported for a URL

#get request to httpbin.org

httr::GET("https://httpbin.org/get")

POST("https://httpbin.org/post")

url="https://httpbin.org/"

#request with query parameters

x=GET(url,query=list(a=5))

#request with headers

x=GET(url,add_headers(wave="hi"))

#request with a body

x=POST(url,body = list(a=5))



#JSON- JavaScript Object Notation
#widely used in WebAPI 

library(jsonlite)

fromJSON('{"foo":"bar"}',FALSE)
fromJSON('[{"foo":"bar","hello":"world"}]')


# Extract information using Rvest -----------------------------------------

library(rvest)
rm(x,data,url)
frozen=read_html("http://www.imdb.com/title/tt2294629/")

frozen
html_structure(frozen)
as_list(frozen)

xml_children(frozen)
xml_children(frozen)[[2]]

xml_contents(xml_children(frozen)[[2]])

#Basic workflow
#1 download the html and turn into xml file with read_html()
#2. extract specific nodes with html_nodes()
#find all nodes 

itals=html_nodes(frozen,"#titleCast .itemprop")
itals2=html_nodes(frozen,".itemprop .itemprop")
#3. extract specific content from nodes using html_text(),html_name(),
#html_attrs(),html_children(), html_table()

itals

html_text(itals)
html_text(itals2)

html_name(itals)

html_children(itals)



html_attr(itals,"class")

html_attrs(itals)

#we have extracted too much information
vignette("selectorgadget")

#extract out cost of living information from bestplaces.net

url="http://www.bestplaces.net/climate/zip-code/new_york/bethpage/11714"

bp=read_html(url)
bp

names=html_nodes(bp,css = "table")
names
t=data.frame(html_table(names,header=TRUE)[[2]])

url2="https://en.wikipedia.org/wiki/Sensitivity_analysis"
sens=read_html(url2)

alltab=html_nodes(sens,css = "#toc")

alltab
html_text(alltab)
html_name(alltab)

#pull the list of countries by population

url3="https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"
library(rvest)
population=read_html(url3)
population_table=html_node(population,css="table")
html_attrs(population_table)
population_Df=as.data.frame(html_table(population_table,header = TRUE))

#remove the word [Note ] from the countries

pattern="[[Note 0-9]]"


findpat=grep(x = population_Df$`Country (or dependent territory)`,pattern = pattern)
library(stringr)



#Selector Gadged by Hadley Wickham
vignette("selectorgadget")

library(rvest)
html=read_html("http://www.imdb.com/title/tt1490017/")
cast=html_nodes(html,"#titleCast .itemprop")
length(cast)
cast[1:2]

#we need to extract only the names and not the table cell
#revise
cast=html_nodes(html,"#titleCast span.itemprop")
html_text(cast)

storyline=html_nodes(html,'#titleStoryLine p')
html_text(storyline)

#title details

release_Date=html_nodes(html,".txt-block:nth-child(6) , .txt-block:nth-child(6) h4")

html_text(release_Date)


#using packtpub.com
selector='#titleDetails'
url='http://www.imdb.com/title/tt0240772/?ref_=nv_sr_3'
getmoviestory=read_html(url)
library(dplyr)
txt=getmoviestory%>%html_node(selector)%>%html_text()
txt
