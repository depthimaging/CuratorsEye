movpat = result@moves
l = result@lClass

stats = c(0,0,0,0,0,0,0)
visits = c(0,0,0,0,0,0,0)

#1 : 8

for( trackCount in 1:length(movpat)){
  
  if( dim(movpat[[paste("t0",trackCount,sep="")]])[1] > 0) 
    {  
      for( i in 1:dim(movpat[[paste("t0",trackCount,sep="")]][8])[1]){
        if(!movpat[[paste("t0",trackCount,sep="")]][[8]][i]==0) {  
          stats[movpat[[paste("t0",trackCount,sep="")]][[8]][i]] = stats[movpat[[paste("t0",trackCount,sep="")]][[8]][i]]+ movpat[[paste("t0",trackCount,sep="")]][[4]][i]
          visits[movpat[[paste("t0",trackCount,sep="")]][[8]][i]] = visits[movpat[[paste("t0",trackCount,sep="")]][[8]][i]]+ 1
        }    
      }
    
  }
  
}


round_percent <- function(x) { 
  x <- x/sum(x)*100  # Standardize result
  res <- floor(x)    # Find integer bits
  rsum <- sum(res)   # Find out how much we are missing
  if(rsum<100) { 
    # Distribute points based on remainders and a random tie breaker
    o <- order(x%%1, sample(length(x)), decreasing=TRUE) 
    res[o[1:(100-rsum)]] <- res[o[1:(100-rsum)]]+1
  } 
  res 
}

visits = round_percent(visits)
agg = data.frame("item" = c(1,2,3,4,5,6,7) ,"holding"= round(stats,0),"attention"= visits)
metastats = toJSON(agg, pretty = T)
writeLines(metastats, paste("../statvis","/data/metastats.json",sep="") )

xxx = c()
xxx$tracks= movpat
meta = toJSON(xxx, pretty = T)
writeLines(meta, paste("../statvis","/data/meta.json",sep="") )


newd = toJSON(l, pretty = T)
writeLines(newd, paste("../statvis","/data/out.json",sep="") )









