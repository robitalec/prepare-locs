library(targets)


library(data.table)


# tar_option_set(format = 'qs')

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
		dates,
		prep_dates(selects, details$tz),
		pattern = map(selects, details)
	)


	# options
	# read in
	# prep
	# write out
)
