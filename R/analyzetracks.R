#Wrapper for scripts for analyzing tracks

source("camera_functions.R")
source("intercamera.R")

dup_mat = matrix(nrow = length(globalized_tracks), ncol = length(globalized_tracks))
for(tno in 1:length(globalized_tracks))
{
  tnoc = 1
  while(tnoc <= length(globalized_tracks))
  {
    if(tnoc == tno) tnoc = tnoc+1 
    intercamera_return = duplicate_trackpoints(globalized_tracks[[tno]], globalized_tracks[[tnoc]])
    if(is.null(intercamera_return)) dup_mat[tnoc,tno] = NA
    else dup_mat[tnoc,tno] = length(intercamera_return[intercamera_return == TRUE])
    # dup_mat[tnoc, tno] = intercamera_return$stD
    tnoc = tnoc+1
  }
}
