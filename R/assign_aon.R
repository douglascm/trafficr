#' AON assignment
#'
#' Perform the all-or-nothing assignment of
#' Frank-Wolfe algorithm in the User Equilibrium
#' Traffic Assignment Model. This function is a wrapper for dodgr 'R/dodgr_flows_aggregate.R'
#' for more information on the function see dodgr documentation
#'
#' @param graph graph object created with configure_graph() function
#' @param from Vector or matrix of points from which aggregate flows are to be calculated
#' @param to Vector or matrix of points to which aggregate flows are to be calculated
#' @param flows Matrix of flows with nrow(flows)==length(from) and ncol(flows)==length(to)
#'
#' @return graph object with assignment on 'flow' column
#'
#' @export

assign_aon <- function(graph,from,to,flows){

   dodgr_flows_aggregate(graph,from,to,flows)
}
