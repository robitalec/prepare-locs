library(targets)

library(data.table)


# tar_option_set(error = 'workspace')#format = 'qs')

lapply(dir('R', '*.R', full.names = TRUE), source)

list(
	tar_target(
		meta,
		metadata()
	),

	tar_target(
		paths,
		meta$path,
		pattern = map(meta),
		format = 'file'
	),

	tar_target(
		reads,
		read_data(paths, meta),
		pattern = map(paths, meta)
	),

	tar_target(
		renames,
		set_colnames(
			DT = reads,
			long = meta$long,
			lat = meta$lat,
			id = meta$id,
			date = meta$date,
			time = meta$time,
			datetime = meta$datetime,
			extracols = meta$extracols
		),
		pattern = map(reads, meta)
	),

	tar_target(
		filters,
		filter_locs(renames),
		pattern = map(renames)
	),

	tar_target(
		dates,
		prep_dates(filters, meta$tz),
		pattern = map(filters, meta)
	),

	tar_target(
		coords,
		project_locs(dates, meta$epsgin, meta$epsgout),
		pattern = map(dates, meta)
	),

	tar_target(
		exports,
		export_csv()
	)
)
