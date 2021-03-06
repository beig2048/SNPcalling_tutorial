#Scripts for taking a 0,1,2 genotype matrix and running basic analyses (PCA, FST)

setwd('~/Desktop/SNPcalling_from_RNAseq')
snps<-read.delim('ahy_snps.012',header=F,na=-1,row.names=1)
pos<-read.delim('ahy_snps.012.pos',header=F)
indv<-read.delim('ahy_snps.012.indv',header=F)

colnames(snps)<-paste(pos[,1],pos[,2],sep=':')
rownames(snps)<-indv[,1]
snps<-as.matrix(snps)

#read in meta data
meta<-read.delim('meta.txt')

#plot a PCA with colors that represent populations
pc.out<-prcomp(snps)
summary(pc.out)
plot(pc.out$x[,1],pc.out$x[,2],col=meta$Pool)

install.packages('hierfstat')
library(hierfstat)

#prepare 0,1,2 matrix in hierfstat format
#we use our pca to separate samples into 
#clusters to test for genetic differentiation
hf<-snps
hf[hf==0]<-11
hf[hf==1]<-12
hf[hf==2]<-22
pop=as.numeric(pc.out$x[,1]>2)+1
hf<-as.data.frame(cbind(pop,snps))

#calculate Weir-Cockerham Fst
fst.out<-wc(hf)

#global estimate
fst.out$FST

#look at fst distribution across sites
site.fst<-fst.out$per.loc[['FST']]
hist(site.fst)


