# Export ------------------------------------------------------------------

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
#' @export
#'
#' @examples
export_csv <- function(DT, outpath, name, splitBy) {
	if (is.na(splitBy)) {
		o <- file.path(outpath, paste0(name, '.csv'))
		data.table::fwrite(DT, o)
		return(o)
	} else {
		DT[, {
			o <- file.path(outpath, paste(name, '_', splitBy, '.csv'))
			data.table::fwrite(.SD, o)
			return(o)
		}, by = splitBy]
	}
}
