#' Export CSVs
#'
#' Minimal wrapper around fwrite, to write separate CSVs if splitBy is provided
#'
#' @param DT
#' @param outpath
#' @param name
#' @param splitBy
#'
#' @return
#' @author Alec L. Robitaille
#' @export
#'
#' @examples
export_csv <- function(DT, outpath, splitBy, extracols) {
	data.table::setalloccol(DT)

	outname <- DT$name[[1]]

	if (!is.na(extracols)) {
		selextra <- unlist(extracols)[unlist(extracols) %in% colnames(DT)]
		data.table::setnames(DT, selextra, to_snake_case(selextra))
	}

	if (is.na(splitBy)) {
		o <- file.path(outpath, paste0(outname, '.csv'))
		data.table::fwrite(DT, o)
		data.table::data.table(
			name = outname,
			output_path = o,
			n_rows = nrow(DT),
			split_by = NA,
			column_names = list(colnames(DT))
		)
	} else {
		snakesplit <- to_snake_case(splitBy)
		out <- DT[, {
			o <- file.path(outpath, paste0(outname, '_', .BY[[1]], '.csv'))
			data.table::fwrite(.SD, o)
			list(name = outname, output_path = o, n_rows = .N,
					 split_by = snakesplit, column_names = list(colnames(DT)))
		}, by = eval(snakesplit)]
		out[, .SD, .SDcols = -snakesplit]
	}
}


to_snake_case <- function(x) {
	gsub('[^0-9a-z]', '_', tolower(x))
}
