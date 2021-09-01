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
		lapply(unique(DT[[snakesplit]]), function(asplit) {
			o <- file.path(outpath, paste0(outname, '_', asplit, '.csv'))
			odt <- DT[get(snakesplit) == asplit]
			data.table::fwrite(odt, o)
			list(name = outname, output_path = o, n_rows = nrow(odt),
					 split_by = snakesplit, column_names = list(colnames(odt)))
		})
	}
}


to_snake_case <- function(x) {
	gsub('[^0-9a-z]', '_', tolower(x))
}
