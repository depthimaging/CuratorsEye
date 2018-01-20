movpat = result@moves
l = result@lClass

stats = c(0,0,0,0,0,0,0)
visits = c(0,0,0,0,0,0,0)


for( trackCount in 1:length(movpat)){
  
  if( dim(movpat[[paste("t0",trackCount,sep="")]])[1] > 0) 
    {
  
      for( i in 1:dim(movpat[[paste("t0",trackCount,sep="")]][8])[1]){
    
        stats[movpat[[paste("t0",trackCount,sep="")]][[8]][i]] = stats[movpat[[paste("t0",trackCount,sep="")]][[8]][i]]+ movpat[[paste("t0",trackCount,sep="")]][[3]][i]
        visits[movpat[[paste("t0",trackCount,sep="")]][[8]][i]] = visits[movpat[[paste("t0",trackCount,sep="")]][[8]][i]]+ 1
    
      }
    
  }
  
}

agg = data.frame("item" = c(0,1,2,3,4,5,6) ,"holding"= stats,"attention"=visits)
metastats = toJSON(agg, pretty = T)
writeLines(metastats, paste("../statvis","/data/metastats.json",sep="") )

xxx = c()
xxx$tracks= movpat
meta = toJSON(xxx, pretty = T)
writeLines(meta, paste("../statvis","/data/meta.json",sep="") )


newd = toJSON(l, pretty = T)
writeLines(newd, paste("../statvis","/data/out.json",sep="") )









