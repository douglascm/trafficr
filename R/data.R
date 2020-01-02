#' Demand data for Sioux Falls network
#'
#' A dataset containing an OD matrix of vehicles for the Sioux Falls network
#'
#' @format A data frame with 528 rows and 3 variables:
#' \describe{
#'   \item{orig}{id of origin}
#'   \item{dest}{id of destination}
#'   \item{demand}{number of vehicles in respect to the OD pair}
#'   ...
#' }
"sioux_demand"
#' Zone data for Sioux Falls network
#'
#' A sf object containing the zones to be used with the network
#'
#' @format A data frame with 528 rows and 3 variables:
#' \describe{
#'   \item{id_zone}{zone id (integer)}
#'   \item{x}{Longitude in WGS84 (numeric)}
#'   \item{y}{Latitude in WGS84 (numeric)}
#'   \item{geometry}{sf object geometry}
#'   ...
#' }
"sioux_zones"
#' Network data for Sioux Falls network
#'
#' A sf object containing the road network
#'
#' @format A data frame with 38 rows and 13 variables:
#' \describe{
#'   \item{id_link}{link id (integer)}
#'   \item{ffs_fw}{forward free flow speed in km/h (numeric)}
#'   \item{ffs_bw}{backward free flow speed in km/h (numeric)}
#'   \item{cap_fw}{forward link capacity in veh/h (numeric)}
#'   \item{cap_bw}{backward link capacity in veh/h (numeric)}
#'   \item{addv_fw}{forward additional cost (numeric)}
#'   \item{addv_bw}{backward additional cost (numeric)}
#'   \item{wg_fw}{forward cost weight (numeric)}
#'   \item{wg_bw}{backward cost weight (numeric)}
#'   \item{alpha}{BPR alpha parameter (numeric)}
#'   \item{beta}{BPR beta parameter (numeric)}
#'   \item{cost}{actual cost (numeric)}
#'   \item{geometry}{sf object geometry}
#'   ...
#' }
"sioux_network"