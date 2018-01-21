getTracks = function(egtrack,bpts_df)
{
    # if(dim(egtrack)<10)
    # next

    ##print(paste('track:',tri))
  
    #egtrack = egtrack
        
  #(length(egtrack) > 1) &&
    if (  (! is.na(bpts_df)) )
    {
    
    #bpts_df = data.frame()
    
    #source("find_stops.R")


    
    #movpat[[paste("t0",trackCount,sep="")]] = x_df
    egtrack@data$stop = rep(1,dim(egtrack)[1])
    for(k in 1:(dim(bpts_df)[1]))  
    {
        egtrack@data$stop[bpts_df[k,1]:bpts_df[k,2]]=0
    }
        
    ##egtrack@data$speed = 
    #movpat[[paste("t0",trackCount,sep="")]][[8]][0]
    
    #temp = as.data.frame( globalized_json [[ egtrack@data$misc.camera[1]]][egtrack@data$misc.t_id[1]])
    
    
    temp = as.data.frame(egtrack@data)
    colnames(temp) = sapply(strsplit(names(temp),"[.]"), `[`, 2)
    
    temp = cbind(temp, "x" = egtrack@sp@coords[,1])
    temp = cbind(temp, "y" = egtrack@sp@coords[,2])
    temp = cbind(temp, "time" = egtrack@endTime)
    temp = cbind(temp, "speed" = c( 0 , egtrack@connections$speed) )
    
    
    
    
    #l[[paste("t0",trackCount,sep="")]] = temp
    
    #trackCount=trackCount+1

        return_temp = temp    
    } else {
      egtrack@data$stop = rep(0,dim(egtrack)[1])
      
      temp = as.data.frame(egtrack@data)
      colnames(temp) = sapply(strsplit(names(temp),"[.]"), `[`, 2)
      
      temp = cbind(temp, "x" = egtrack@sp@coords[,1])
      temp = cbind(temp, "y" = egtrack@sp@coords[,2])
      temp = cbind(temp, "time" = egtrack@endTime)
      temp = cbind(temp, "speed" = c( 0 , egtrack@connections$speed) )
      
      
      
      return_temp =  temp
    }
    return(return_temp)
}
