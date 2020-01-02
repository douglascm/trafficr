#' Link from to link time
#'
#' Based on current link flow, use link
#' time performance function to compute the link
#' traveling time.
#' The input is an array.
#'
#' @param graph gGraph object created with configure_graph() function
#' @param flow Traffic flow from current iteration
#'
#' @return Vector with current link times
#'
#' @export

link_flow_to_link_time <- function(graph,flow){

   mapply(function(flow,link_free_time,link_capacity,link_alpha,link_beta) {
      link_time_performance(flow, link_free_time, link_capacity,link_alpha,link_beta)
   },flow,graph$d,graph$cap,graph$alpha,graph$beta)
}
