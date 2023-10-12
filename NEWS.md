# v 0.1.2 (2023-10-12)

* prepare raw Fogo caribou relocations (#1)

# v 0.1.1 (2021-08-08)

* make prepare locs flexible to only process files found on current machine


# v 0.1.0 (2021-08-08)

## Initial release

* full workflow from reading raw data, to check locs and QA columns, to casting
dates and projecting locs, to exporting CSVs

* functions:
	+ `metadata()`
	+ `check_meta()`
	+ `read_data()`
	+ `set_colnames()`
	+ `prep_dates()`
	+ `check_locs()`
	+ `project_locs()`
	+ `export_csv()`
