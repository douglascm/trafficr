#' FW Equilibrium assignment
#'
#' Solve the traffic flow assignment model (user equilibrium) by Frank-Wolfe algorithm (all the necessary data must be  properly input into the model in advance).
#'
#' @param graph Graph object created with configure_graph() function
#' @param demand Demand object created with configure_demand() function
#' @param col Column from demand file selected for assignment
#' @param max_iterations Maximum number of iterations for Frank-Wolfe algorithm
#'
#' @return Graph object with assignment on 'flow' column
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
#'
#' @export

solve_ue <- function(graph,demand,col,max_iterations=200){

   dodgr_cache_off()
   start <- Sys.time()

   if(!hasArg(col)){
      stop('missing demand column input for assigment')
   }

   # configure demand
   from <- sort(unique(demand$orig_graph))
   to <- sort(unique(demand$dest_graph))
   flows <- as.data.table(demand) %>% dcast.data.table(.,orig_graph ~ dest_graph,value.var = col,fill = 0) %>%
      .[,orig_graph:=NULL] %>% data.matrix(.); rownames(flows) <- from

   #clear any past assignment
   if("flow" %in% colnames(graph)) {graph[,flow:=NULL]}

   # Step 0: based on the x0, generate the x1
   graph[,c('d_weighted')] <- graph[,c('d')]
   flow <- assign_aon(graph,from,to,flows)$flow

   counter <- 1;solved <- F
   while(solved==F){

      # Step 1 & Step 2: Use the link flow matrix -x to generate the time, then generate the auxiliary link flow matrix -y
      new_link_time <- link_flow_to_link_time(graph,flow)
      graph[,c('d_weighted')] <- new_link_time

      #graph[,c('time','time_weighted')] <- new_link_time
      auxiliary_flow <- assign_aon(graph,from,to,flows)$flow

      # Step 3: Linear Search
      opt_theta <- golden_section(flow, auxiliary_flow, graph)

      # Step 4: Using optimal theta to update the link flow matrix
      new_flow <- flow + opt_theta * (auxiliary_flow - flow)
      #graph %>% cbind(.,flow,auxiliary_flow,new_flow)

      # Step 5: Check the Convergence, if FALSE, then return to Step 1
      if(is_convergent(flow, new_flow) | counter>max_iterations){
         solved <- T
         final_flow <- new_flow
         iterations_times <- counter
      } else{
         flow <- new_flow
         counter <- counter + 1
      }
   }

   graph[,c('flow')] <- final_flow
   graph[,c('d_weighted','time',"time_weighted")] <- new_link_time

   dodgr_cache_on()

   time_elapsed  <- round(Sys.time() - start,2)
   cat(paste0('Number of iterations: ',counter,'\n','Time elapsed: ',time_elapsed,'s\n'))
   graph
}
