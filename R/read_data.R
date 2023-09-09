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
		files <- fs::dir_ls(path, recurse = TRUE, type = 'file',
												glob = 'csv|CSV|Csv')
		temporary_sub <-
			files[grep('GPS_Collar00993_FO2016005|GPS_Collar01082_FO2016002',
								 files, invert = TRUE)]
		DT <- data.table::rbindlist(
			lapply(temporary_sub, function(f) {
				fread(f, colClasses = 'character')[, filename := f]
				fread(f, colClasses = 'character', select = selects)[, filename := f]
			}),
			fill = TRUE)
	} else {
		DT <- data.table::fread(path, select = selects)
	}

	DT[, name := meta$name]
	DT
}
