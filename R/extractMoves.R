
 # 1 
flag = FALSE
xxx = c()
k=1
if(length(bpts)>0) {
  if(length(bpts)==2)
  {
    if(bpts[1] == 1)
    {
      xxx[1] = bpts[1]
      xxx[2] = bpts[2]
      
      nexti = bpts[2]+1
      if(nexti<dim(egtrack_coords)[1]) { 
        xxx[3] = nexti
        xxx[4] = dim(egtrack_coords)[1]
      }
    } else {
      xxx[1] = 1
      xxx[2] = bpts[1]-1
      
      xxx[3] = bpts[1]
      xxx[4] = bpts[2]
      
    }
    
  } else 
    {
    for(i in 1:length(bpts)) 
      {
      xxx[k] = bpts[i]
      k = k+1
      if(flag == TRUE) {
        xxx[k] = bpts[i]
        k = k+1
        flag = FALSE
      }
      
      if(i %% 2==0 && i<length(bpts)) {
        xxx[k] = bpts[i]
        flag = TRUE
        k = k+1
      }
    }
  }
}
# end 1


# 2
total_duration = as.numeric(difftime(egtrack@endTime[length(egtrack@endTime)],egtrack@endTime[1], units="secs"))
  
x_mat = matrix(data = xxx, ncol = 2, byrow = TRUE, dimnames = list(c(), c("start", "end")))
x_df = as.data.frame(x_mat)
duration = vector(length = dim(x_df)[1])
percentage = vector(length = dim(x_df)[1])
for(i in 1:dim(x_df)[1])
{
  duration[i] = difftime(egtrack@endTime[x_df$end[i]], egtrack@endTime[x_df$start[i]], units = "secs")
  
  #rounding down the percentage
  percentage[i] = round(100* duration[i] / total_duration, 0)
}
# this is to normalize the rounding down
percentage[i] = percentage[i] + 100 - sum(percentage)

x_df = cbind(x_df, as.data.frame(duration))
x_df = cbind(x_df, as.data.frame(percentage))

#duration = vector(length = dim(x_df)[1])
#bpds[round((bpts_df[1,1]+bpts_df[1,2])/2,0),]




start_stop = xxx[1]==bpts[1]
if(start_stop == TRUE) {
  v = rep(1:0,dim(x_df)[1])
} else {
  v = rep(0:1,dim(x_df)[1])
}

    
x_df = cbind(x_df, "stop"=v[1:dim(x_df)[1]])


#center = rep(0,length = dim(x_df)[1])
#center = round((a[,1]+a[,2])/2,0)


x_df$cenX = bpds[round((x_df[,1]+x_df[,2])/2,0),1]
x_df$cenY = bpds[round((x_df[,1]+x_df[,2])/2,0),2]


#source("coordinates.R")


x2 = item[,2:3]

library("fields")

for(i in 1:dim(x_df)[1])
{
  
  if(x_df$stop[i]==1)
  {
    
    x1 = data.frame("x"= rep(x_df$cenX[i],dim(item)[1]) ,"y"=rep(x_df$cenY[i],dim(item)[1]))
    
    
    dist = rdist.vec(x1, x2)
    
    closest_item_index = which.min(dist)
  
    closest_item_name = as.character(item[closest_item_index,1])
    
    closest_item_x = item[closest_item_index,2]
    closest_item_y = item[closest_item_index,3]
    
    x_df$item[i] = closest_item_index
    x_df$item_x[i] = closest_item_x
    x_df$item_y[i] = closest_item_y
  }
  else {
    x_df$item[i] = 0
    x_df$item_x[i] = 0
    x_df$item_y[i] = 0
   
  }
  
  
}

} else # if no stops available 
{
  x_df = data.frame()
}
