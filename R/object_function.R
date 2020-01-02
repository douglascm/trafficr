#' Objective function
#'
#' Objective function in the linear search step
#' of the optimization model of user equilibrium
#' traffic assignment problem, the only variable
#' is mixed_flow in this case.
#'
#' @param mixed_flow Vector with flows used by golden section search technique
#' @param graph Graph object created with configure_graph() function
#'
#' @return Vector with objective function calculation from flow
#'
#' @export

object_function <- function(mixed_flow,graph){ #mixed_flow<-(1 - leftX) * flow + leftX * auxiliary_flow

   val = 0
   for(i in 1:length(mixed_flow)){
      val <- val + link_time_performance_integrated(mixed_flow[i], t0=graph$d[i], capacity=graph$cap[i])
   }
   val
}
