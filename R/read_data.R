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
read_data <- function(path, meta, deploy) {
	selects <- meta[, na.omit(c(x_long, y_lat, id, date, time, datetime, unlist(extracols)))]

	if (fs::is_dir(path) && meta$name == 'NL-Fogo-Caribou-Telemetry') {
		files <- fs::dir_ls(path, recurse = FALSE, type = 'file',
												glob = '*csv|*CSV|*Csv')

		# Without headers
		regex_with_headers <- 'old_collars|Collar00993_FO2016005|Collar01082_FO2016002'
		# with_headers <- files[grep(regex_with_headers, files, invert = FALSE)]
		without_headers <- files[grep(regex_with_headers, files, invert = TRUE)]

		DT <- data.table::rbindlist(lapply(without_headers, function(f) {
			fread(
				f,
				colClasses = 'character',
				select = grep('filename|id', selects, invert = TRUE, value = TRUE)
			)[, filename := f]
		}),
		use.names = FALSE)

		DT_wo[, collar_id := as.integer(gsub('Collar', '',
																			tstrsplit(basename(filename), '_')[[2]]))]

		set_id(DT_wo, meta$name, deploy)

		# Old collars
		path_old_collars <- as.character(files[grep('old_collars', files)])
		DT_old_collars <- fread(path_old_collars, header = TRUE)
		DT_old_collars[, filename := path_old_collars]
		DT_old_collars[, collar_id := NA]
		sub_cols <- c('Long', 'Lat', 'Date', 'Time', 'Navigation', 'DOP',
									'filename', 'collar_id', 'Animal_ID')
		DT_old_collars_sub <- DT_old_collars[, .SD, .SDcols = sub_cols]
		setnames(DT_old_collars_sub, sub_cols, colnames(DT))

		rbindlist(list(DT, DT_old_collars_sub),
							use.names = TRUE)
		# With headers

	} else {
		DT <- data.table::fread(path, select = selects)
	}

	DT[, name := meta$name]
	DT
}
