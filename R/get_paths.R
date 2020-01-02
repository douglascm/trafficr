#' Get paths
#'
#' Wrapper function for dodgr function 'R/dodgr_paths.R'
#'
#' @param graph Graph object created with configure_graph() function
#' @param demand Demand object created with configure_demand() function
#'
#' @return List of list of paths tracing all connections between nodes such that if x <- dodgr_paths (graph, from, to), then the path between from[i] and to[j] is x [[i]] [[j]].
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
#' paths <- get_paths(graph,demand)
#'
#' @export

get_paths <- function(graph,demand){
    
   from <- sort(unique(demand$orig_graph))
   to <- sort(unique(demand$dest_graph))
   dodgr_paths(graph,from,to)
}
