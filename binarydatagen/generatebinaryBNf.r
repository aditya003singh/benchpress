library(RBGL)
library(pcalg)
library(BiDAG)


#n  number of nodes
#ii set seed to reproduce
#baseline vector with 2 values min and max probability of 1 for nodes which have no parents but have children (upstream)
#d average neighborhood size (children+parents)

generatebinaryBN <- function (n, ii, baseline, d=2) {
  set.seed(ii)
  maxneib<-5
  while(maxneib>4) { #here we make sure graphs do not have to big parent sets
    # here we can define the type of the graph
    # mydag<-randDAG(n, d=2, method ="er") 
    mydag<-randDAG(n, d=d, method ="barabasi",par1=0.3)
    # mydag<-randDAG(n, d=2, method ="power")
    adj<-dag2adjacencymatrix(mydag)
    maxneib<-max(apply(adj,2,sum))
  }
  parlist<-list()
  np<-vector()
  for (i in 1:n) {
    parlist[[i]]<-sort(which(adj[,i]==1))
    np[i]<-length(parlist[[i]])
  }
  mapping<-BNmaps(np)
  ord<-as.numeric(tsort(mydag)) #to gerate data we need the ordering of the dag
  fp<-list()
  for (i in ord) {
    fp[[i]]<-generatefactors(np[i],baseline,mapping)
  }
  res<-list()
  res$DAG<-mydag
  res$adj<-adj
  res$parlist<-parlist
  res$np<-np
  res$fp<-fp
  res$ord<-ord
  res$map<-mapping
  res$skel<-1*(adj|t(adj))
  res$skel<-ifelse(upper.tri(res$skel)==TRUE,res$skel,0)
  return (res)
}
generatebinaryBN.data <- function (n,binaryBN,samplesize) {
  BNsample<-matrix(ncol=n,nrow=samplesize)
  
  for (k in 1:samplesize) {
    for (i in binaryBN$ord) {
      if(binaryBN$np[i]==0) { #if node has no parents sample 0/1
        if (sum(binaryBN$adj[i,])==0) { #if node has no children sample 0/1
          BNsample[k,i]<-rbinom(1,1,0.03)
        } else {
          BNsample[k,i]<-rbinom(1,1,binaryBN$fp[[i]][1])}
      } else {
        binaryvec<-BNsample[k,binaryBN$parlist[[i]]]
        BNsample[k,i]<-rbinom(1,1,binaryBN$fp[[i]][which(binaryBN$map$index[[binaryBN$np[i]]]==BinToDec(binaryvec))])
      }
    }
  }
  return(BNsample)
}
BNmaps <- function (np) {
  uniquenp<-setdiff(unique(np),0)
  maps<-list()
  maps$partable<-list()
  maps$index<-list()
  for (i in uniquenp) {
    maps$partable[[i]]<-expand.grid(rep(list(0:1),i))
    maps$index[[i]]<-apply(maps$partable[[i]],1,BinToDec)
  }
  return(maps)
}
BinToDec <- function(x)
  sum(2^(which(rev(unlist(strsplit(as.character(x), "")) == 1))-1))
generatefactors <- function (nf,baselinevec,mapping) {
  prob0<-vector(length=2^nf)
  if (nf>0) {
    prob0[1]<-runif(1, min = 0.01, max = 0.1) #probability of 1 when parents are present
  } else {
    prob0[1]<-runif(1, min = baselinevec[1], max = baselinevec[2]) #probability of 1 when node has no parents
  }
  if(nf>0){
    if (4<5) {
      if (nf<3) {
        factorstrength<-runif(nf, min = 0.4, max = 0.9)
        prob0[2:(2^nf)]<-(apply(t(t(as.matrix(mapping$partable[[nf]]))*factorstrength),1,sum))[2:(2^nf)]
        prob0[which(prob0>0.95)]<-0.95
      } else {
        factorstrength<-runif(nf, min = 0.4, max = 0.9)
        prob0[2:(2^nf)]<-(apply(t(t(as.matrix(mapping$partable[[nf]]))*factorstrength),1,sum))[2:(2^nf)]
        prob0[which(prob0>0.95)]<-0.95
      }
    } else {
      if (nf<3) {
        factorstrength<--runif(nf, min = 0.45, max = 0.85)
        prob0[2:(2^nf)]<-(apply(t(t(as.matrix(mapping$partable[[nf]]))*factorstrength),1,sum))[2:(2^nf)]
        prob0[which(prob0<0.05)]<-0.05
      } else {
        factorstrength<--runif(nf, min = 0.45, max = 0.85)
        prob0[2:(2^nf)]<-(apply(t(t(as.matrix(mapping$partable[[nf]]))*factorstrength),1,sum))[2:(2^nf)]
        prob0[which(prob0<0.05)]<-0.05
      }
    }
  }
  return(prob0)
}


#how to use
binBN<-generatebinaryBN(n=100,1,c(0.1,0.9),d=2)
bindata10n<-generatebinaryBN.data(n=100,binBN,1000)

#example of structure learning
myscore<-scoreparameters(n=100,"bde",bindata10n,bdepar=list(chi=1,edgepf=1))
itmap<-iterativeMCMCsearch(n=100,myscore)
iterations.check(itmap,binBN$DAG)