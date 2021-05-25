library(targets)


library(data.table)


tar_option_set(format = 'qs')


list(
	tar_target(
		pp,
		print(DT),
		pattern = map(DT)
	)
	# paths
	# options
	# read in
	# prep
	# write out
)
