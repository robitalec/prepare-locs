#' Set id from collar id and deployment
#'
#' @param DT
#' @param name
#' @return
#' Input DT with id appended from matching collar id / deployment sheet
#' @export
#' @author Alec L. Robitaille
set_id <- function(DT, name, deployment) {
	if (grepl(name, 'NL-Fogo-Caribou-Telemetry'))  {
		DT[, parsed_V2 := as.IDate(parse_date(V2, default_tz = 'UTC'))]

		DT[deployment, id := id_animal,
			 on = .(collar_id == id_collar,
			 			 parsed_V2 >= capture_date,
			 			 parsed_V2 <= end_date)]

		DT[, parsed_V2 := NULL]

		return(DT)
	}
}
