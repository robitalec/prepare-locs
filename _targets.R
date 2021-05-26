library(targets)


library(data.table)


tar_option_set(format = 'qs')

source('scripts/data.R')


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
	)


	# options
	# read in
	# prep
	# write out
)
