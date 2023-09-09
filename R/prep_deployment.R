#' Prep deployment sheet where necessary
#'
#' Currently only Fogo
#'
#' @param meta
#'
#' @return
#' meta updated with new path to prepared deployment sheet
#' @export
#' @author Alec L. Robitaille
#'
#' @examples
prep_deployment <- function(meta) {
	if (!is.na(meta$deployment) &&
			grepl('NL-Fogo-Caribou-Telemetry', meta$name) &&
			file.exists(meta$deployment)) {

		deploy <- fread(meta$deployment)

		prepared <- deploy[, .(start_date = parse_date(`Capture date`),
													 end_date = parse_date(`Mortality Date`)),
											 by = .(animal_id = `Animal No.`, collar_id = ID)]
		prepared[is.na(end_date), end_date := parse_date(Sys.Date())]

		prepared_path <- file.path('input', paste0(meta$name, '_deployment.csv'))
		fwrite(prepared, prepared_path)

		meta$deployment <- prepared_path
		meta
	} else {
		meta
	}
}
