#source https://www.packtpub.com/mapt/video/Big%20Data%20&%20Business%20Intelligence/9781786464781/14202/14203/Scraping+Web+Pages+and+Process+Texts

#using the rvest pacakge

library(rvest)

url="http://cwe.mitre.org/data/definitions/306.html"

techimpact='#Potential_Mitigations'

#import the complete html page

cwe306=read_html(url)

cwe306

#let's read the copied selection

library(dplyr)

text=cwe306%>%
  html_node(css=techimpact)%>%
  html_table()
text
text$X1[6]

#lets try the same using an xpath selector

xpathsel='//*[@id="Potential_Mitigations"]'

table1=cwe306%>%
  html_node(xpath = xpathsel)%>%
  html_text()
table1
