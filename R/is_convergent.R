#' Convergency test
#'
#' Regard those two link flows lists as the point
#' in Euclidean space R^n, then judge the convergence
#' under given accuracy criterion.
#' Here the formula
#' ERR = || x_{k+1} - x_{k} || / || x_{k} ||
#' is recommended.
#'
#' @param flow Past iteration calculated traffic flow
#' @param new_flow Current iteration calculated traffic flow
#' @param accuracy Error accuracy value. The accuracy is suggested to be set as 1e-6.
#' 
#' @importFrom matrixcalc frobenius.norm
#'
#' @return Boolen (TRUE) or (FALSE)
#'
#' @export

is_convergent <- function(flow, new_flow, accuracy=1E-6){

   err <- frobenius.norm(flow - new_flow) / frobenius.norm(flow)

   if(err < accuracy){
      T
   } else F
}
