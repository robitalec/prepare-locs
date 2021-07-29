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
export_csv <- function(DT, outpath, splitBy) {
	outname <- DT$name[[1]]
	if (is.na(splitBy)) {
		o <- file.path(outpath, paste0(outname, '.csv'))
		data.table::fwrite(DT, o)
		o
	} else {
		DT[, {
			o <- file.path(outpath, paste0(outname, '_', .BY[[1]], '.csv'))
			data.table::fwrite(.SD, o)
			o
		}, by = splitBy]$V1
	}
}
