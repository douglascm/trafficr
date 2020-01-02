#' FW Equilibrium assignment
#'
#' The golden-section search is a technique for
#' finding the extremum of a strictly unimodal
#' function by successively narrowing the range
#' of values inside which the extremum is known
#' to exist. For more details please refer to:
#' https://en.wikipedia.org/wiki/Golden-section_search
#' Initial params, notice that in our case the
#' optimal theta must be in the interval [0, 1]
#'
#' @param flow Past iteration calculated traffic flow
#' @param auxiliary_flow Current iteration calculated traffic flow
#' @param graph Graph object created with configure_graph() function
#' @param accuracy Golden section accuracy value. The accuracy is suggested to be set as 1e-8.
#'
#' @return optima theta from golden section technique
#'
#' @export


golden_section <- function(flow, auxiliary_flow, graph, accuracy= 1e-8){

   LB <- 0;UB <- 1;gp <- 0.618
   leftX <- LB + (1 - gp) * (UB - LB)
   rightX <- LB + gp * (UB - LB)
   continue<-T
   while(continue){
      val_left = object_function(flow + leftX * (auxiliary_flow-flow),graph)
      val_right = object_function(flow + rightX * (auxiliary_flow-flow),graph)

      if(val_left <= val_right){
         UB <- rightX
      } else LB <- leftX

      if(abs(LB - UB) < accuracy) {
         opt_theta <- (rightX + leftX) / 2.0
         continue <- F
      } else{
         if(val_left <= val_right){
            rightX = leftX
            leftX = LB + (1 - gp) * (UB - LB)
         } else{
            leftX = rightX
            rightX = LB + gp*(UB - LB)
         }
      }

   }
   opt_theta
}
