#' Conversion from data.frame to adjacency matrix
#' 
#' Creates an adjacency matrix from an edge list data.frame.
#' 
#' @param df data.frame containing edge data
#' @param source.column Name of column containing source nodes. Defaults to "source".
#' @param target.column Name of column containing target nodes. Defaults to "target".
#' @param value.column Name of column containing edge values. Defaults to "value".
#' 
#' @return A list with two components:
#' \item{matrix}{Adjacency matrix}
#' \item{labels}{Names of nodes, in same order as rows/columns of adjacency matrix}
#' 
#' @details
#' Utilizes a script similar to \url{https://observablehq.com/@d3/chord-diagram} adapted to work with r2d3.
#' 
#' @examples
#' df = data.frame(source = c("a", "a", "b"),
#'                 target = c("b", "c", "c"),
#'                 value = c(1, 2, 3))
#'                 
#' df.to.adjacency(df)
#' 
#' @export

df.to.adjacency <-
  function(df, source.column = "source", target.column = "target", value.column = "value"){
    labels = unique(c(df$source, df$target))
    m = matrix(0, nrow = length(labels), ncol = length(labels))
    colnames(m) = labels
    rownames(m) = labels
    
    m[as.matrix(df[,c(source.column, target.column)])] = df[,value.column]
    
    return(list(matrix = m, labels = labels))
  }
