

# Datetime ----------------------------------------------------------------
#' Prepare datetime column
#'
#' @param tz character; time zone.
#' @inheritParams cast_cols
#'
#' @return
#' data.table with datetime in UTC time, idate, itime and DOY
#' @export
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' prep_dates(DT, 'Canada/Newfoundland')
prep_dates <- function(DT, tz) {
	check_truelength(DT)
	check_col(DT, 'datetime', 'datetime')

	if (missing(tz)) {
		stop('must provide a tz argument')
	}

	DT[, datetime := parsedate::parse_date(datetime, default_tz = tz)]

	DT[, idate := data.table::as.IDate(datetime)]
	DT[, itime := data.table::as.ITime(datetime)]

	DT[, doy := data.table::yday(idate)]
	DT[, yr := data.table::year(idate)]
	DT[, mnth := data.table::month(idate)]
}




# Locs --------------------------------------------------------------------
#' Project locs
#' @inheritParams prep_dates
#' @param EPSG numeric; EPSG code
#'
#' @return
#' @export
#'
#' @examples
project_locs <- function(DT, epsgin, epsgout) {
	check_truelength(DT)
	if (!is.numeric(epsgout)) stop("epsgout must be numeric")

	coords <- c('long', 'lat')
	projcoords <- paste0('proj', coords)

	lapply(coords, function(x) check_col(DT, x))
	lapply(coords, function(x) check_type(DT, x, 'double'))
	lapply(projcoords, function(x) overwrite_col(DT, x))

	if (is.na(as.numeric(epsgin))) {
		if (!epsgin %in% colnames(DT)) {
			stop('if epsgin is a character, it must refer to column name in DT')
		}
		check_type(DT, epsgin, 'integer')

		DT[, (projcoords) :=
			 	data.table::as.data.table(
			 		sf::sf_project(
			 			pts = as.matrix(.SD, ncol = 2),
			 			from = sf::st_crs(.BY[[1]]),
			 			keep = TRUE,
			 			to = sf::st_crs(epsgout))
			 	),
			 .SDcols = coords,
			 by = epsgin]
	} else if (!is.na(as.numeric(epsgin))) {
		DT[, (projcoords) :=
			 	data.table::as.data.table(
			 		sf::sf_project(
			 			pts = as.matrix(.SD, ncol = 2),
			 			from = sf::st_crs(as.numeric(epsgin)),
			 			keep = TRUE,
			 			to = sf::st_crs(epsgout))
			 	),
			 .SDcols = coords]
	}
}


#' Check long and lat
#'
#' @param DT data.table
#'
#' @return
#' data.table
#' @export
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' check_longlat(DT)
check_longlat <- function(DT) {
	check_truelength(DT)

	if (DT[, !is.numeric(long)]) DT[, long := is.numeric(long)]
	if (DT[, !is.numeric(lat)]) DT[, lat := is.numeric(lat)]

	DT[!between(long, -180, 360), drop := 'long not between -180, 360']
	DT[!between(lat, -90, 90), drop := 'lat not between -90, 90']

	DT[is.na(long), drop := 'long is NA']
	DT[is.nan(long), drop := 'long is NaN']
	DT[is.na(lat), drop := 'lat is NA']
	DT[is.nan(lat), drop := 'lat is NaN']

	DT[long == 0,  drop := 'long is 0']
	DT[lat == 0,  drop := 'lat is 0']

	DT[long == lat, drop := 'long == lat']

	DT
}

#' Check loc meta
#'
#' Check location data's meta information eg. map quality, DOP, manual exclusion
#'
#' @param DT data.table
#'
#' @return
#' data.table
#' @export
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' check_longlat(DT)
check_locs_meta <- function(DT) {
	# if ('SEX' %in% colnames(DT)) {
	# 	DT[grepl('F', SEX)]
	# }

	if ('Map_Quality' %in% colnames(DT)) {
		DT[Map_Quality == 'N', drop := 'Map_Quality is N']
		DT[, Map_Quality := NULL]
	}

	if ('EXCLUDE' %in% colnames(DT)) {
		DT[EXCLUDE == 'Y', drop := 'EXCLUDE is Y']
		DT[, EXCLUDE := NULL]
	}

	if ('LOCQUAL' %in% colnames(DT)) {
		# DT[LOCQUAL %in% c(1, 2, 3)]
		# TODO LOCQUAL
		# DT[, LOCQUAL := NULL]
	}

	# TODO: VALIDATED

	if ('COLLAR_TYPE_CL' %in% colnames(DT)) {
		DT[COLLAR_TYPE_CL == 'GPS']
		DT[, COLLAR_TYPE_CL := NULL]
	}
}


# Filter ------------------------------------------------------------------
filter_locs <- function(DT) {

	check_longlat(DT)
	check_locs_meta(DT)
	DT[!is.na(drop), c('long', 'lat') := NaN]
	return(DT)
}






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
