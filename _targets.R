# === Prepare locs: targets workflow --------------------------------------
# Alec Robitaille



# Functions ---------------------------------------------------------------
targets::tar_source('R')


# Renv --------------------------------------------------------------------
activate()
snapshot()
restore()


# Options -----------------------------------------------------------------
tar_option_set(workspace_on_error = TRUE,
							 format = 'qs')





# Targets -----------------------------------------------------------------
list(
	tar_target(
		meta,
		metadata()
	),

	# Note: this prepare locs workflow only processes files if it finds they
	# 			exist at the specified path in metadata.
	tar_target(
		checkmeta,
		check_meta(meta),
		cue = tar_cue('always')
	),

	tar_target(
		deploy_paths,
		checkmeta$deployment,
		pattern = map(checkmeta),
		format = 'file'
	),

	tar_target(
		paths,
		checkmeta$path,
		pattern = map(checkmeta),
		format = 'file'
	),

	tar_target(
		reads,
		read_data(paths, checkmeta, deploy),
		pattern = map(paths, checkmeta, deploy)
	),

	tar_target(
		deploy,
		read_deployment(deploy_paths),
		pattern = map(deploy_paths)
	),

	tar_target(
		renames,
		set_colnames(
			DT = reads,
			x_long = checkmeta$x_long,
			y_lat = checkmeta$y_lat,
			id = checkmeta$id,
			date = checkmeta$date,
			time = checkmeta$time,
			datetime = checkmeta$datetime,
			extracols = checkmeta$extracols
		),
		pattern = map(reads, checkmeta)
	),

	tar_target(
		dates,
		prep_dates(renames, checkmeta$tz),
		pattern = map(renames, checkmeta)
	),

	tar_target(
		checks,
		check_locs(dates, checkmeta, deploy),
		pattern = map(dates, checkmeta, deploy)
	),

	tar_target(
		checkflags,
		setcolorder(checks[, .(name = name[[1]], .N), flag], c(2, 1, 3)),
		pattern = map(checks)
	),

	tar_target(
		filters,
		checks[is.na(flag)][, flag := NULL],
		pattern = map(checks)
	),

	tar_target(
		coords,
		project_locs(filters, checkmeta$epsgin, checkmeta$epsgout),
		pattern = map(filters, checkmeta)
	),

	tar_target(
		exports,
		export_csv(coords, 'output', checkmeta$splitBy, checkmeta$extracols),
		pattern = map(coords, checkmeta)
	),

	tar_target(
		readme,
		file.path('README.Rmd'),
		format = 'file'
	),
	tar_target(
		render_readme,
		{exports; checkflags; render(readme); file.remove('README.html'); 'README.md'},
		format = 'file'
	)
)
