#' Demand configuration
#'
#' Tranforms demand data from source origin and destination to match origin and destination from graph/zone objects
#'
#' @param demand demand_file source file with demand data
#' @param zones zones object created with configure_graph()
#'
#' @return demand object compatible with solve_ue() function
#' 
#' @import data.table dodgr
#' @importFrom sf st_read st_coordinates st_nearest_feature st_cast st_set_geometry st_as_sf st_bbox
#' @importFrom dplyr mutate as_tibble filter group_by summarise left_join %>% bind_cols n
#' @importFrom methods hasArg
#' @importFrom stats time
#' 
#' @examples
#' flist <- configure_graph(sioux_network,sioux_zones)
#' graph <- flist[[1]]
#' zones <- flist[[2]]
#' demand <- configure_demand(sioux_demand,zones)
#'
#' @export

configure_demand <- function(demand,zones){
   
   demand <- as.data.table(demand)
   #check demand consistency
   required_demand_cols <- c('orig','dest')
   check_demand <- sapply(required_demand_cols, function(x) {x %in% names(demand)})
   if(all(check_demand)==F){
      if(length(required_demand_cols[!required_demand_cols])>1){
         cat('"',paste(required_demand_cols[!required_demand_cols],collapse = ','),'" columns are missing from demand file\n',sep = "")
      } else cat('"',paste(required_demand_cols[!required_demand_cols],collapse = ','),'" column is missing from demand file\n',sep = "")
   }

   demand[,`:=`(orig_graph=zones$id_graph[match(as.numeric(orig),zones$id_zone)],
                dest_graph=zones$id_graph[match(as.numeric(dest),zones$id_zone)])]
   demand[,colnames(demand)[!colnames(demand) %in% required_demand_cols],with=F][, lapply(.SD, sum, na.rm=TRUE), by=c('orig_graph','dest_graph')]
}
