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

	if (fs::is_dir(path) && meta$name == 'NL-Fogo-Caribou-Telemetry') {
		files <- fs::dir_ls(path, recurse = TRUE, type = 'file',
												glob = 'csv|CSV|Csv')
		regex_with_headers <- 'GPS_Collar00993_FO2016005|GPS_Collar01082_FO2016002'
		# with_headers <- files[grep(regex_with_headers, files, invert = FALSE)]
		without_headers <- files[grep(regex_with_headers, files, invert = TRUE)]

		DT <- data.table::rbindlist(lapply(without_headers, function(f) {
			fread(
				f,
				colClasses = 'character',
				select = grep('filename', selects, invert = TRUE, value = TRUE)
			)[, filename := f]
		}),
		use.names = FALSE)

		set_id(DT, meta$name, deploy)

	} else {
		DT <- data.table::fread(path, select = selects)
	}

	DT[, name := meta$name]
	DT
}
