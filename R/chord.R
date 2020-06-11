#' Chord diagram
#' 
#' Creates chord diagram from edge data.frame.
#' 
#' @param df data.frame containing edge data
#' @param source.column Name of column containing source nodes. Defaults to "source".
#' @param target.column Name of column containing target nodes. Defaults to "target".
#' @param value.column Name of column containing edge values. Defaults to "value".
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param viewer "internal" to use the RStudio internal viewer pane for output; "external" to display in an external RStudio window; "browser" to display in an external browser.
#' 
#' @return A d3 object as returned by r2d3::r2d3.
#' 
#' @details
#' Utilizes a script similar to \url{https://observablehq.com/@d3/chord-diagram} adapted to work with r2d3.
#' 
#' @examples
#' labels = c("spam", "eggs", "foo", "bar")
#' 
#' df = data.frame(source = rep(labels, each = 4),
#'                 target = rep(labels, times = 4),
#'                 value = c(11975, 5871, 8916, 2868,
#'                           1951, 10048, 2060, 6171,
#'                           8010, 16145, 8090, 8045,
#'                           1013, 990, 940, 6907))
#' 
#' chord(df)
#' 
#' @export

chord <-
  function(df, source.column = "source", target.column = "target", value.column = "value",
           width = NULL, height = NULL, viewer = c("internal", "external", "browser")){
    
    # Parsing arguments
    viewer = match.arg(viewer)
    
    # JS file locations
    package.dir = system.file(package = "r2d3.common")
    chord.script.file = paste0(package.dir, "/js/chord.js")
    
    # Creating d3 diagram
    d3 = r2d3::r2d3(
      data = df.to.adjacency(df, source.column, target.column, value.column),
      script = chord.script.file,
      width = width,
      height = height,
      viewer = viewer
    )
    
    # Return diagram
    return(d3)
  }
