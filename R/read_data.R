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
read_data <- function(path, meta) {
	selects <- meta[, na.omit(c(x_long, y_lat, id, date, time, datetime, unlist(extracols)))]

	if (fs::is_dir(path)) {
		DT <- data.table::rbindlist(
	DT[, name := meta$name]
	DT
}
