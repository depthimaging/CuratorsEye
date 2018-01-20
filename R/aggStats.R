

movpat = c()
stats = c()

l = c()
trackCount = 1

for(tri in 1:(length(g_tracks)))
{

    getTracks = function(g_tracks,)
    {
        if(dim(g_tracks[[tri]])<10)
        next
    
        print(paste('track:',tri))
        egtrack = g_tracks[[tri]]
        
        if ( dim(egtrack@sp)[1] > 10) {
        
        bpts_df = data.frame()
        
        source("find_stops.R")


        if(dim(bpts_df)[1]==0){
            next
        }
        
        #movpat[[paste("t0",trackCount,sep="")]] = x_df
        g_tracks[[tri]]@data$stop = rep(1,dim(g_tracks[[tri]])[1])
        for(k in 1:(dim(bpts_df)[1]))  
        {
            g_tracks[[tri]]@data$stop[bpts_df[k,1]:bpts_df[k,2]]=0
        }
            
        ##g_tracks[[tri]]@data$speed = 
        #movpat[[paste("t0",trackCount,sep="")]][[8]][0]
        
        #temp = as.data.frame( globalized_json [[ g_tracks[[tri]]@data$misc.camera[1]]][g_tracks[[tri]]@data$misc.t_id[1]])
        
        
        temp = as.data.frame(g_tracks[[tri]]@data)
        colnames(temp) = sapply(strsplit(names(temp),"[.]"), `[`, 2)
        
        temp = cbind(temp, "x" = g_tracks[[tri]]@sp@coords[,1])
        temp = cbind(temp, "y" = g_tracks[[tri]]@sp@coords[,2])
        temp = cbind(temp, "time" = g_tracks[[tri]]@endTime)
        temp = cbind(temp, "speed" = c( 0 , g_tracks[[tri]]@connections$speed) )
        
        
        
        
        l[[paste("t0",trackCount,sep="")]] = temp
        
        trackCount=trackCount+1
        
        }  
    }

}

stats = c(0,0,0,0,0,0,0)
visits = c(0,0,0,0,0,0,0)


for( trackCount in 1:length(movpat)){
  
  for( i in 1:dim(movpat[[paste("t0",trackCount,sep="")]][8])[1]){
  
      stats[movpat[[paste("t0",trackCount,sep="")]][[8]][i]] = stats[movpat[[paste("t0",trackCount,sep="")]][[8]][i]]+ movpat[[paste("t0",trackCount,sep="")]][[3]][i]
      visits[movpat[[paste("t0",trackCount,sep="")]][[8]][i]] = visits[movpat[[paste("t0",trackCount,sep="")]][[8]][i]]+ 1
  
  }
}



newd = toJSON(l, pretty = T)

writeLines(newd, paste("../statvis","/data/out.json",sep="") )

xxx = c()

xxx$tracks= movpat

#meta = toJSON(unname(split(xxx, 1:nrow(xxx))))
meta = toJSON(xxx, pretty = T)

writeLines(meta, paste("../statvis","/data/meta.json",sep="") )
#cond <- sapply(l, function(x) x$time >= "2017-12-29 15:23:00 CET" & x$time <= "2017-12-29 15:23: CET" )



agg = data.frame("item" = c(0,1,2,3,4,5,6) ,"holding"= stats,"attention"=visits)
metastats = toJSON(agg, pretty = T)

writeLines(metastats, paste("../statvis","/data/metastats.json",sep="") )
