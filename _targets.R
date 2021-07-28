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
		checkmeta,
		check_meta(meta)
	),

	tar_target(
		paths,
		checkmeta$path,
		pattern = map(checkmeta),
		format = 'file'
	),

	tar_target(
		reads,
		read_data(paths, checkmeta),
		pattern = map(paths, checkmeta)
	),

	tar_target(
		renames,
		set_colnames(
			DT = reads,
			long = checkmeta$long,
			lat = checkmeta$lat,
			id = checkmeta$id,
			date = checkmeta$date,
			time = checkmeta$time,
			datetime = checkmeta$datetime,
			extracols = checkmeta$extracols
		),
		pattern = map(reads, checkmeta)
	),

	tar_target(
		filters,
		filter_locs(renames),
		pattern = map(renames)
	),

	tar_target(
		dates,
		prep_dates(filters, checkmeta$tz),
		pattern = map(filters, checkmeta)
	),

	tar_target(
		coords,
		project_locs(dates, checkmeta$epsgin, checkmeta$epsgout),
		pattern = map(dates, checkmeta)
	),

	tar_target(
		exports,
		export_csv(coords, 'output', checkmeta$name, checkmeta$splitBy),
		format = 'file'
	)
)
