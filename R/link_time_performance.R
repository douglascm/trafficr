#' Link time performance
#'
#' Performance function, which indicates the relationship
#' between flows (traffic volume) and travel time on
#' the same link. According to the suggestion from Federal
#' Highway Administration (FHWA) of America, we could use
#' the following function:
#' t = t0 * (1 + alpha * (flow / capacity))^beta
#'
#' @param flow Vector with current traffic flow
#' @param t0 Link free-flow times
#' @param capacity Link capacity
#' @param alpha alpha BPR function parameter
#' @param beta beta BPR function parameter
#' 
#' @return Vector with link times adjusted by link flow
#'
#' @export

link_time_performance <- function(flow, t0, capacity,alpha=0.15,beta=4){

   t0 * (1 + alpha * ((flow/capacity)^beta))
}
