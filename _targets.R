library(targets)


library(data.table)


tar_option_set(format = 'qs')

source('R/data.R')
source('R/functions.R')
source('R/internal.R')

list(
	tar_target(
		getdetails,
		data_details()
	),

	tar_target(
		details,
		getdetails,
		pattern = map(getdetails)
	),

	tar_target(
		paths,
		details$path,
		pattern = map(details),
		format = 'file'
	),

	tar_target(
		reads,
		fread(paths),
		pattern = map(paths)
	),

	tar_target(
		selects,
		select_cols(
			DT = reads,
			id = details$id,
			datetime = details$datetime,
			xcoord = details$xcoord,
			ycoord = details$ycoord,
			extracols = details$extracols
		),
		pattern = map(reads, details)
	)


	# options
	# read in
	# prep
	# write out
)
