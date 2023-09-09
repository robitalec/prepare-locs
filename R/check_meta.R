#' Check metadata
#'
#' Checks for duplicate names and filters if file doesn't exist on the current
#' machine
#'
#' @param meta
#' @return
#' @author Alec L. Robitaille
#' @export
check_meta <- function(meta) {
	N_name <- meta[, .N, by = name]$N

	if (any(N_name) > 1) stop('found duplicates in "name" column, check metadata')

	meta <- meta[, prep_deployment(.SD), by  = path]

	return(meta[file.exists(path)])
}
