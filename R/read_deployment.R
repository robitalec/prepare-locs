#' Read deployment sheet where necessary
#'
#' @param meta
#'
#' @return
#' meta updated with new path to prepared deployment sheet
#' @export
#' @author Alec L. Robitaille
#'
#' @examples
read_deployment <- function(deployment) {
	if (!is.na(deployment) &&
			grepl('NL-Fogo-Caribou-Telemetry', meta$name) &&
			file.exists(deployment)) {

		deploy <- fread(deployment)

		deploy[is.na(end_date), end_date := Sys.Date()]

		prepared_path <- file.path('input', paste0(meta$name, '_deployment.csv'))
		fwrite(prepared, prepared_path)

		meta$deployment <- prepared_path
		meta
	} else {
		meta
	}
}
