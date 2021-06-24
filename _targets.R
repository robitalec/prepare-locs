library(targets)


library(data.table)


# tar_option_set(error = 'workspace')#format = 'qs')

source('R/data.R')
source('R/functions.R')
source('R/internal.R')

list(
	tar_target(
		details,
		data_details()
	),

	tar_target(
		paths,
		details$path,
		pattern = map(details),
		format = 'file'
	),

	tar_target(
		reads,
		read_data(paths, details),
		pattern = map(paths, details)
	),

	tar_target(
		selects,
		select_cols(
			DT = reads,
			long = details$long,
			lat = details$lat,
			id = details$id,
			date = details$date,
			time = details$time,
			datetime = details$datetime,
			extracols = details$extracols
		),
		pattern = map(reads, details)
	),

	tar_target(
		casts,
		check_cols(selects),
		pattern = map(selects)
	),

	tar_target(
		dates,
		prep_dates(casts, details$tz),
		pattern = map(casts, details)
	),

	tar_target(
		coords,
		project_locs(dates, details$epsgin, details$epsgout),
		pattern = map(dates, details)
	)
)
