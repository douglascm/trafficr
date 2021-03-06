% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/link_flow_to_link_time.R
\name{link_flow_to_link_time}
\alias{link_flow_to_link_time}
\title{Link from to link time}
\usage{
link_flow_to_link_time(graph, flow)
}
\arguments{
\item{graph}{gGraph object created with configure_graph() function}

\item{flow}{Traffic flow from current iteration}
}
\value{
Vector with current link times
}
\description{
Based on current link flow, use link
time performance function to compute the link
traveling time.
The input is an array.
}
