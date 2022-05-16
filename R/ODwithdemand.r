#' Add Demands to OD Data
#'
#' This function adds demands to the OD data.
#'
#' @param ODdata The OD data with "car_driver" counts.
#'
#' @return The output is an OD data with demands generated by using the
#' "car_driver" counts.
#'
#' @keywords ODwithdemand
#'
#' @examples
#' wholenet <- getnet("oxford uk")
#' oxford.od <- ODdata("oxford uk")
#' mainnet <- mainnet(wholenet)
#' cntrnet <- contract(mainnet)
#' ODlist <- getODnodes(cntrnet, oxford.od)
#' oxford.main.nodes <- ODlist[[2]]
#' oxford.od <- addODnodeID(oxford.main.nodes, oxford.od)
#' oxford.od.matrix <- ODwithdemand(oxford.od)
#'
#' @export

ODwithdemand <- function(ODdata){
  p <- nchar(as.character(max(ODdata$to_nodeID)))
  ODdata$OD <- ODdata$from_nodeID + ODdata$to_nodeID/(10^p)
  ODdemand <- tapply(ODdata$car_driver, ODdata$OD, sum)
  ODdemand[ODdemand < 0.1] <- 0.1
  demand.from <- tapply(ODdata$from_nodeID, ODdata$OD, mean)
  demand.to <- tapply(ODdata$to_nodeID, ODdata$OD, mean)
  od.matrix <-  data.frame(demand = ODdemand,
                                  from_nodeID = demand.from,
                                  to_nodeID = demand.to)
  od.matrix <- od.matrix[od.matrix$from_nodeID != od.matrix$to_nodeID, ]
  return(od.matrix)
}
