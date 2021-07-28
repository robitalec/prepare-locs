
# prepare-locs

A `targets` workflow for processing animal relocation data from the
WEEL.

``` r
targets::tar_visnetwork()
```

![](README_files/figure-gfm/viz-1.png)<!-- -->

## Output

| Column name   | Description                                                                  |
|---------------|------------------------------------------------------------------------------|
| id            | unique animal identifier                                                     |
| datetime      | date time in UTC                                                             |
| long          | longitude, EPSG code provided in `metadata()`. see `R/metadata.R`            |
| lat           | latitude, EPSG code provided in `metadata()`. see `R/metadata.R`             |
| flag          | comma separated flags indicating why locs are dropped and set to NaN         |
| doy           | date of year, integer. see `data.table::yday()`                              |
| yr            | year, integer. see `data.table::year()`                                      |
| mnth          | month, integer. see `data.table::month()`                                    |
| projlong      | projected x coordinate, output EPSG code in `metadata()`. see `R/metadata.R` |
| projlat       | projected y coordinate, output EPSG code in `metadata()`. see `R/metadata.R` |
| \[extracols\] | eg. HERD. as provided in the `metadata()`. see `R/metadata.R`.               |

## Etc

Screening GPS fixes:

-   <https://ropensci.github.io/CoordinateCleaner/articles/Comparison_other_software.html>
    -   missing coordinates
    -   lat == 0
    -   long == 0
    -   lat == long
    -   …
-   *Effects of habitat on GPS collar performance: using data screening
    to reduce location error*. Lewis et al. 2007
    -   drop 2D fixes
    -   threshold PDOP
-   *Screening GPS telemetry data for locations having unacceptable
    error*. Laver et al. 
