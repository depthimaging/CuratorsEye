source("find_stops.R")
source("aggStats.R")

setClass(Class = "stopmat" , slots = c("breaks","moves") )

setClass(Class = "exportClass" , slots = c("breaks","lClass","moves") )

#This is for printing original globalized_tracks!!
# for(track_id in 1:length(globalized_tracks))
# {
#   break_points[[track_id]] = demarcate_stops(track_id)
# }
stat_version = function(merged_tracks)
{
  movpat = c()
  l = c()
  
  breaks = list()
  for(track_id in 1:length(merged_tracks))
  {
    #breaks[[track_id]] = demarcate_stops(track_id, merged_tracks,movpat)

    stops_return = demarcate_stops(track_id, merged_tracks)

    breaks[[track_id]] = stops_return@breaks

    movpat[[paste("t0",track_id,sep="")]] = stops_return@moves
    
    
    l[[paste("t0",track_id,sep="")]] = getTracks(merged_tracks[[track_id]],stops_return@breaks)

    # #The following line for plotting globalized_tracks!
    # breaks[[track_id]] = demarcate_stops(track_id, globalized_tracks)
    # breaks[[track_id]] = demarcate_stops(track_id, merged_tracks_s)
    # breaks[[track_id]] = demarcate_stops(track_id, merged_tracks_d)
  }
  
  stops_moves = new("exportClass", breaks = breaks , lClass = l ,moves = movpat)
  
  return(stops_moves)
}


merged_tracks_s = s_merged[!is.na(s_merged)]
merged_tracks_d = d_merged[!is.na(d_merged)]

null_filter = lapply(X = merged_tracks_d, FUN = is.null)
# merged_tracks_d = d_merged[!is.na(d_merged)]
merged_tracks_d = merged_tracks_d[null_filter == FALSE]

result = stat_version(merged_tracks_d)

breaks = result@breaks

print("Finished finding stops!")

source('export.R')