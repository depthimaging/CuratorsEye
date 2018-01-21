# Global wrapper

#Importing, cleaning & CRS
source("import.R")

#Analyzing
source("analyzetracks.R")

#Calculating statistics
source("analyzestats.R")


c
st = c()
mv = c()
for(i in 1: length(xxx$tracks) )
{
  t = xxx$tracks[[i]]
  
  
  st[[i]] = sum( t[t$stop==1,]$percentage )
  
  mv[[i]] = sum( t[t$stop==0,]$percentage )
  
  
}
