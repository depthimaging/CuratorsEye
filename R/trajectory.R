library("sp")
library("spacetime")
library("trajectories")

global_json = globalized_json
create_trajectories = function(global_json)
{
  cam_trajs = list()
  for(cams in global_json)
  {
    each_cam = list()
    for(tracks in cams)
    {
      sp_obj = SpatialPointsDataFrame(coords = data.frame(tracks$x, tracks$y), data = subset(tracks, select = -c(1:2)))
      stidf_obj = STIDF(sp = sp_obj, time = sp_obj@data$time, data = subset(data.frame(misc = sp_obj@data), select = -c(2)))
      track_obj = Track(stidf_obj)
      each_cam = c(each_cam, list(track_obj))
    }
    cam_trajs = c(cam_trajs, each_cam)
  }
  return(cam_trajs)
}
