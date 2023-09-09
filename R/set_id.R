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
		DT[, collar_id := tstrsplit(basename(filename), '_')[[2]] |>
			 	gsub(pattern = 'Collar', replacement = '') |>
			 	as.integer()]
		DT[, parsed_V2 := parse_date(V2, default_tz = 'UTC')]

		deploy <- fread(deployment)

		DT[deploy, animal_id := animal_id,
			 on = .(collar_id == collar_id,
			 			 parsed_V2 >= start_date,
			 			 parsed_V2 <= end_date)]

		DT[, parsed_V2 := NULL]

		return(DT)

	}
}
