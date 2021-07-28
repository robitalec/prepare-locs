#' Check metadata
#' @param meta
#' @return
#' @author Alec L. Robitaille
#' @export
check_meta <- function(meta) {
	N_name <- meta[, .N, by = name]$N

	if (any(N_name) > 1) stop('found duplicated names, check metadata')

	return(meta)
}
