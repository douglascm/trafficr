#' Plot flowmap
#'
#' Quick timap plot from flows in network
#'
#' @param network Simple feature collection containing network with flow data
#' @param flow_factor Exponential factor for flow map display
#' @param scale_factor Tmap scale factor for tm_lines function
#' @param show_labels Should map (tmap) display text labels? (TRUE) or (FALSE)
#' @param bbox sf bbox object
#'
#' @return Nothing; the function outputs in plot window
#' 
#' @import data.table dodgr tmap
#' @importFrom sf st_read st_coordinates st_nearest_feature st_cast st_set_geometry st_as_sf st_bbox
#' @importFrom dplyr mutate as_tibble filter group_by summarise left_join %>% bind_cols n
#' @importFrom methods hasArg
#' @importFrom stats time
#'
#' @examples
#' flist <- configure_graph(sioux_network,sioux_zones,use_cost_col=TRUE)
#' graph <- flist[[1]]
#' zones <- flist[[2]]
#' demand <- configure_demand(sioux_demand,zones)
#' graph <- solve_ue(graph,demand,col = 'demand')
#' network <- graph_to_sf(graph,sioux_network)
#' plot_flowmap(network,show_labels = TRUE)
#'
#' @export

plot_flowmap <- function(network,flow_factor=1,scale_factor=10,show_labels=FALSE,bbox){

   tmap_mode('plot')
   map <- network %>% mutate(flow_scaled=round(flow^flow_factor,0))

   if(!hasArg(bbox)) {bbox<-st_bbox(map)}

   if(!all(sapply(c('flow_fw','flow_bw'), function(x) x %in% colnames(network))==TRUE)){
      stop('flow data missing from network')
   }

   if(show_labels==T){
   tm_shape(map, bbox = bbox) + tm_graticules(ticks = FALSE,col='lightgrey') +
      tm_lines(col = 'flow_scaled',lwd = 'flow_scaled',scale = scale_factor,palette = "-RdYlGn") +
      tm_text('flow',along.lines = T,size=0.7,col='grey30') +
      tm_layout(frame=T,inner.margins=0.05) + tm_legend(show=FALSE)
   } else {
      tm_shape(map, bbox = bbox) + tm_graticules(ticks = FALSE,col='lightgrey') +
         tm_lines(col = 'flow_scaled',lwd = 'flow_scaled',scale = scale_factor,palette = "-RdYlGn") +
         tm_layout(frame=T,inner.margins=0.05) + tm_legend(show=FALSE)
   }
}
