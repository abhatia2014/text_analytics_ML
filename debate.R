#first commit on debate.R- again
#loading the libraries
libs=c("tm","plyr","class")
lapply(libs,require,character.only=TRUE)
#set options
options(stringsAsFactors = FALSE)

#get the data
library(tm)
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

#now cbind the names of the candidates to the dataframe

s.df=cbind(s.df,rep(result[["name"]],nrow(s.df)))
#name the last column
colnames(s.df)[ncol(s.df)]="targetCandidate"
s.df[,"targetCandidate"]
s.df
sum(is.na(s.df))
# no NAs
head(s.df)
ncol(s.df)
nrow(s.df)
#train the model

train.idx=sample(nrow(s.df),ceiling(nrow(s.df)*0.5))
test.idx=(1:nrow(s.df))[-train.idx]

#we are going to pull out the name of the candidate and put it as a separate variable

s.df.cand=s.df[,"targetCandidate"]
s.df.nl=s.df[,!colnames(s.df) %in% "targetCandidate"]
dim(s.df.cand[train.idx])
#create the model

knnpred=knn(s.df.nl[train.idx,],s.df.nl[test.idx,],s.df.cand[train.idx])

#do the prediction
#create the prediction model

conf.mat=table("predictions"=knnpred, Actual=s.df.cand[test.idx])
