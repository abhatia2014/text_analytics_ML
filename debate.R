#loading the libraries
libs=c("tm","plyr","class")
lapply(libs,require,character.only=TRUE)
#set options
options(stringsAsFactors = FALSE)

#get the data

debate=read.csv("debate.csv",stringsAsFactors = FALSE)
debate_Clinton=as.data.frame(debate[debate$Speaker=="Clinton",c(3)])
colnames(debate_Clinton)="text"
debate_Clinton$candidate="Clinton"

#similarly separate out the data for Trump
debate_Trump=as.data.frame(debate[debate$Speaker=="Trump",c(3)])
colnames(debate_Trump)="text"
debate_Trump$candidate="Trump"
#likewise for Holt
debate_Holt=as.data.frame(debate[debate$Speaker=="Holt",c(3)])
colnames(debate_Holt)="text"
debate_Holt$candidate="Holt"
#build the term document matrix
#mycorpus=rbind(debate_Clinton,debate_Trump,debate_Holt)
#create a corpus
corpuslist=c(debate_Clinton,debate_Trump,debate_Holt)
mycorpus=Corpus(VectorSource(corpuslist))


#function to clean a corpus

cleanCorpus=function(corpus){
  corpus.tmp=tm_map(corpus,removePunctuation)
  corpus.tmp=tm_map(corpus.tmp,stripWhitespace)
  corpus.tmp=tm_map(corpus.tmp,tolower)
  corpus.tmp=tm_map(corpus,removeWords,stopwords("english"))
  return(corpus.tmp)
}

# now let's clean the corpus

mycorpus=cleanCorpus(mycorpus)
inspect(mycorpus)

#convert the mycorpus to a term document matrix

mycorpus_TDM=TermDocumentMatrix(mycorpus)

#let's remove sparse terms and setup an acceptable level for sparse terms

mycorpus_TDM_sparse=removeSparseTerms(mycorpus_TDM,0.7)

#get the result out with the names of candidates with the tdm
candnames=c("Clinton","Trump","Holt")

result=list(name=candnames,tdm=mycorpus_TDM_sparse)

#let's inspect the documents
str(mycorpus_TDM_sparse)

#transpose the tdm to data matrix 

s.mat=t(data.matrix(result[["tdm"]]))
#convert it to a dataframe

s.df=as.data.frame(s.mat,stringsAsFactors = FALSE)
