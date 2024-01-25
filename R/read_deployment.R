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
	if (!is.na(deployment) && file.exists(deployment)) {
		deploy <- fread(deployment)

		deploy[is.na(end_date), end_date := as.IDate(Sys.Date())]

		return(deploy)
	}
}
