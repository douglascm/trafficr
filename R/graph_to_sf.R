#' Outputs traffic loaded network file
#'
#' Merges information from graph object into source network file, generating a shapefile with traffic flow information
#'
#' @param graph graph object created with configure_graph() function
#' @param network sf object containing network data
#'
#' @return Simple feature collection containing network data
#' 
#' @import data.table dodgr
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
#'
#' @export

graph_to_sf <- function(graph,network){
   
   if("flow" %in% colnames(graph)){
      cols <- c("d_weighted","time_weighted","flow")
   } else cols <- c("d_weighted","time_weighted")
   link_par <- graph[,lapply(.SD, sum), .SDcols = cols,by=c('id_link','dir')] %>%
      dcast.data.table(.,id_link ~ dir,value.var = cols) %>%
      setnames(.,colnames(.),gsub('1','fw',colnames(.))) %>%
      setnames(.,colnames(.),gsub('2','bw',colnames(.)))
   network <- network %>% left_join(link_par,by=c('id_link'='id_link')) %>%
      mutate(flow=round(flow_fw+flow_bw,0))
   network
}
