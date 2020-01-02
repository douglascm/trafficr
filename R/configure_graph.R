#' Graph configuration
#'
#' Tranforms network data from source network and zones
#'
#' @param network sf object containing network data
#' @param zones sf object containing zone data
#' @param turn_penalty Adds turn penalty (see dodgr documentation on turn penalty from function 'R/weight-streetnet.R')
#' @param left_side Does traffic travel on the left side of the road (TRUE) or the right side (FALSE)? - only has effect on turn angle calculations for edge times. (see dodgr documentation on turn penalty from function 'R/weight-streetnet.R')
#' @param addvalue_cols Does network shapefile has columns 'addv_fw' and 'addv_bw' for added cost in links? (TRUE) or (FALSE)
#' @param weighted Does network shapefile has columns 'wg_fw' and 'wg_bw' for a cost multiplication factor in links? (TRUE) or (FALSE)
#' @param performance_measures Does network shapefile has columns 'alpha' and 'beta' for usage on BPR funcion? (TRUE) or (FALSE)
#' @param use_cost_col Use time column as cost (opposite to speed and distance)? (TRUE) or (FALSE)
#'
#' @return graph object ready for usage on solve_ue() function
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
#'
#' @export

configure_graph <- function(network,zones,turn_penalty=F,left_side=F,addvalue_cols=F,weighted=F,performance_measures=F,use_cost_col=F){

   net_verts <- network %>% st_cast(.,"POINT",warn = F) %>% 
      bind_cols(.,as_tibble(st_coordinates(.))) %>% mutate(id_vert=1:n())
   net_nodes <- net_verts %>% as.data.table(.) %>% .[,c('id_vert','id_link','X','Y'),with=F] %>%
      .[,seq:=1:.N,by="id_link"] %>% .[, .SD[c(1,.N)], by='id_link'] %>% .[,seq:=NULL] %>%
      st_as_sf(., coords = c('X', 'Y'), crs=4326, remove=F) %>% mutate(id_node=1:n())
   zones <- zones %>% mutate(id_vert=net_verts$id_vert[suppressMessages(st_nearest_feature(.,net_verts))])
   network <- net_verts %>% filter(id_vert %in% unique(c(zones$id_vert,net_nodes$id_vert))) %>%
      group_by(id_link) %>% summarise(do_union = FALSE) %>% st_cast("LINESTRING") %>% left_join(network %>% st_set_geometry(NULL),by='id_link') %>%
      mutate(id=1:n()) %>% mutate(highway='primary')

   #check addvalue presence
   if(addvalue_cols==F){
      network <- network %>% mutate(addv_fw=0,addv_bw=0)
   }
   #check performance_measures presence
   if(addvalue_cols==F){
      network <- network %>% mutate(alpha=0.15,beta=4)
   }
   #check weighted presence
   if(weighted==F){
      network <- network %>% mutate(wg_fw=1,wg_bw=1)
   }
   #check use_time_col presence
   if(use_cost_col==F){
      network <- network %>% mutate(cost=0)
   }

   #check network consistency
   required_network_cols <- c('id_link','ffs_fw','ffs_bw','cap_fw','cap_bw','addv_fw','addv_bw','wg_fw','wg_bw','alpha','beta','cost')
   check_net <- sapply(required_network_cols, function(x) {x %in% names(network)})
   if(all(check_net)==F){
      if(length(required_network_cols[!check_net])>1){
         cat('"',paste(required_network_cols[!check_net],collapse = ','),'" columns are missing from network file\n',sep = "")
      } else cat('"',paste(required_network_cols[!check_net],collapse = ','),'" column is missing from network file\n',sep = "")
   }

   #check zone consistency
   required_zone_cols <- c('id_zone','x','y')
   check_zone <- sapply(required_zone_cols, function(x) {x %in% names(zones)})
   if(all(check_zone)==F){
      if(length(required_zone_cols[!check_zone])>1){
         cat('"',paste(required_zone_cols[!check_zone],collapse = ','),'" columns are missing from zone file\n',sep = "")
      } else cat('"',paste(required_zone_cols[!check_zone],collapse = ','),'" column is missing from zone file\n',sep = "")
   }

   if(!all(check_zone,check_net)==T){
      stop('columns are missing from sources, exiting function...\n')
   }

   #check network numeric consistency
   net_num <- sapply(network %>% st_set_geometry(NULL) %>% mutate(highway=NULL), is.numeric)
   if(any(!net_num)==T){
      if(length(required_network_cols[!net_num])>1){
         cat('"',paste(required_network_cols[!net_num],collapse = ','),'" columns are not numeric\n',sep = "")
      } else cat('"',paste(required_network_cols[!net_num],collapse = ','),'" column is not numeric\n',sep = "")
   }

   #check zone numeric consistency
   zon_num <- sapply(zones %>% st_set_geometry(NULL), is.numeric)
   if(any(!zon_num)==T){
      if(length(required_zone_cols[!zon_num])>1){
         cat('"',paste(required_zone_cols[!zon_num],collapse = ','),'" columns are not numeric\n',sep = "")
      } else cat('"',paste(required_zone_cols[!zon_num],collapse = ','),'" column is not numeric\n',sep = "")
   }

   if(!all(zon_num,net_num)==T){
      stop('some columns in sources are not numeric, exiting function...\n')
   }

   if((network %>% group_by(id_link) %>% mutate(n=n()) %>% filter(n>1) %>% nrow())>0){
      stop('non unique id_link...\n')
   }

   if((zones %>% group_by(id_zone) %>% mutate(n=n()) %>% filter(n>1) %>% nrow())>0){
      stop('non unique id_zone\n')
   }

   clear_dodgr_cache()
   dodgr_cache_off()
   graph <- suppressWarnings(weight_streetnet(network,id_col = 'id', type_col = 'highway',
      keep_cols = c('id_link','ffs_fw','ffs_bw','cap_fw','cap_bw','addv_fw','addv_bw','wg_fw','wg_bw','alpha','beta','cost'),turn_penalty = turn_penalty,left_side = left_side)) %>%
      as.data.table(.)
   verts <- dodgr_vertices(graph)
   zones <- zones %>% mutate(id_graph=match_pts_to_graph(verts,zones))

   graph[from_id<to_id,`:=`(ffs=ffs_fw,cap=cap_fw,addv=addv_fw,wg=wg_fw,dir=1)]
   graph[from_id>to_id,`:=`(ffs=ffs_bw,cap=cap_bw,addv=addv_bw,wg=wg_bw,dir=2)]
   graph[, (c('ffs_fw','ffs_bw','cap_fw','cap_bw','wg_fw','wg_bw','addv_fw','addv_bw')) := NULL]
   graph[,`:=`(d_weighted=d*wg+addv,len=d)]
   graph[,`:=`(time=d/(1000*ffs)*3600,time_weighted=d_weighted/(1000*ffs)*3600)]
   graph[,`:=`(d=time,d_weighted=time_weighted,edge_id=1:.N)]
   if(use_cost_col==TRUE){
      graph[,`:=`(d=cost,d_weighted=cost,time=cost,time_weighted=cost)]
   } else graph[,`:=`(cost=NULL)]
   graph <- graph[from_id!=to_id & cap>0]
   dodgr_cache_on()
   cat('zone data.frame created, graph completed without errors...\n')
   list(graph,zones)
}
