#' Check metadata
#' @param meta
#' @return
#' @author Alec L. Robitaille
#' @export
check_meta <- function(meta) {
	N_name <- meta[, .N, by = name]$N

	if (any(N_name) > 1) stop('found duplicates in "name" column, check metadata')

	return(meta)
}
