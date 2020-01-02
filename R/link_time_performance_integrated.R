#' Integration of link time performance
#'
#' The integrated (with repsect to link flow) form of
#' aforementioned performance function.
#' Some optimization should be implemented for avoiding overflow
#'
#' @param flow Vector with current traffic flow
#' @param t0 Link free-flow times
#' @param capacity Link capacity
#' @param alpha alpha BPR function parameter
#' @param beta beta BPR function parameter
#'
#' @return Vector with integrated values from performance function
#'
#' @export

link_time_performance_integrated <- function(flow, t0, capacity,alpha=0.15,beta=4){

   val1 = t0 * flow
   val2 = (alpha * t0) / (capacity ^ beta * (beta + 1)) * flow ^ (beta + 1)
   val1 + val2
}
