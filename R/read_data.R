#' Read data
#'
#' @param path character; path to input file passed to fread
#'
#' @return
#' data.table
#' @export
#' @import data.table
#' @author Alec L. Robitaille
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
read_data <- function(path, details) {
	selects <- details[, na.omit(c(long, lat, id, date, time, datetime, unlist(extracols)))]

	data.table::fread(path, select = selects)
}
