
# prepare-locs

A `targets` workflow for processing animal relocation data from the
WEEL.

``` r
library(targets)
tar_visnetwork()
```

    ## Registered S3 method overwritten by 'printr':
    ##   method                from     
    ##   knit_print.data.frame rmarkdown

![](README_files/figure-gfm/viz-1.png)<!-- -->

## Output: files

``` r
tar_read(exports)
```

    ##  [1] "output/NL-Fogo-Caribou-Telemetry.csv"                     
    ##  [2] "output/NL-Provincial-Caribou-Telemetry_BUCHANS.csv"       
    ##  [3] "output/NL-Provincial-Caribou-Telemetry_GlongEY.csv"       
    ##  [4] "output/NL-Provincial-Caribou-Telemetry_GlongEYVIC.csv"    
    ##  [5] "output/NL-Provincial-Caribou-Telemetry_GlongOSMOlongN.csv"
    ##  [6] "output/NL-Provincial-Caribou-Telemetry_LAPOILE.csv"       
    ##  [7] "output/NL-Provincial-Caribou-Telemetry_MIDlongIDGE.csv"   
    ##  [8] "output/NL-Provincial-Caribou-Telemetry_MTPEYTON.csv"      
    ##  [9] "output/NL-Provincial-Caribou-Telemetry_OLDMANS.csv"       
    ## [10] "output/NL-Provincial-Caribou-Telemetry_POTHILL.csv"       
    ## [11] "output/NL-Provincial-Caribou-Telemetry_STEPHENV.csv"      
    ## [12] "output/NL-Provincial-Caribou-Telemetry_TOPSAILS.csv"      
    ## [13] "output/NL-Provincial-Caribou-Telemetry_UNKNOWN.csv"       
    ## [14] "output/MB-Vita-Elk-Telemetry_Lotek.csv"                   
    ## [15] "output/MB-Vita-Elk-Telemetry_Vectronic.csv"               
    ## [16] "output/MB-longMNP-Elk-Telemetry.csv"

## Output: flag counts

``` r
tar_read(checkflags)
```

| name                             | flag                                                                                           |       N |
|:---------------------------------|:-----------------------------------------------------------------------------------------------|--------:|
| NL-Fogo-Caribou-Telemetry        | NA                                                                                             |  156018 |
| NL-Fogo-Caribou-Telemetry        | long is NA, lat is NA                                                                          |    4621 |
| NL-Fogo-Caribou-Telemetry        | long is NA, lat is NA, loc is duplicated                                                       |   34360 |
| NL-Fogo-Caribou-Telemetry        | loc is duplicated                                                                              |      10 |
| NL-Provincial-Caribou-Telemetry  | Collar type is ARGOS                                                                           |  305866 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N, Collar type is ARGOS                                                        |    1114 |
| NL-Provincial-Caribou-Telemetry  | Collar type is VHF                                                                             |   24053 |
| NL-Provincial-Caribou-Telemetry  | loc is duplicated, Collar type is ARGOS                                                        |      26 |
| NL-Provincial-Caribou-Telemetry  | NA                                                                                             | 1941084 |
| NL-Provincial-Caribou-Telemetry  | DOP &gt; 10                                                                                    |    7352 |
| NL-Provincial-Caribou-Telemetry  | NAV is 2D                                                                                      |   22174 |
| NL-Provincial-Caribou-Telemetry  | long is 0, lat is 0, long == lat, Map\_Quality is N, DOP &gt; 10, NAV is No                    |    4239 |
| NL-Provincial-Caribou-Telemetry  | DOP &gt; 10, NAV is 2D                                                                         |    1112 |
| NL-Provincial-Caribou-Telemetry  | long is 0, lat is 0, long == lat, loc is duplicated, Map\_Quality is N, DOP &gt; 10, NAV is No |    5746 |
| NL-Provincial-Caribou-Telemetry  | loc is duplicated                                                                              |     310 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N, NAV is 2D                                                                   |      83 |
| NL-Provincial-Caribou-Telemetry  | long is 0, lat is 0, long == lat, Map\_Quality is N, NAV is No                                 |    2883 |
| NL-Provincial-Caribou-Telemetry  | long is 0, lat is 0, long == lat, loc is duplicated, Map\_Quality is N, NAV is No              |    7866 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N, DOP &gt; 10, NAV is 2D                                                      |      18 |
| NL-Provincial-Caribou-Telemetry  | loc is duplicated, NAV is 2D                                                                   |      58 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N                                                                              |    8657 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N, DOP &gt; 10                                                                 |      15 |
| NL-Provincial-Caribou-Telemetry  | loc is duplicated, Map\_Quality is N                                                           |      12 |
| MB-Vita-Elk-Telemetry\_Lotek     | fix date before deployment                                                                     |     473 |
| MB-Vita-Elk-Telemetry\_Lotek     | NA                                                                                             |   10022 |
| MB-Vita-Elk-Telemetry\_Lotek     | long is NA, lat is NA, status is not 3D                                                        |     120 |
| MB-Vita-Elk-Telemetry\_Lotek     | status is not 3D                                                                               |      22 |
| MB-Vita-Elk-Telemetry\_Lotek     | long is NA, lat is NA, status is not 3D, fix date before deployment                            |       1 |
| MB-Vita-Elk-Telemetry\_Lotek     | long is NA, lat is NA, loc is duplicated, status is not 3D                                     |       5 |
| MB-Vita-Elk-Telemetry\_Lotek     | loc is duplicated                                                                              |       2 |
| MB-Vita-Elk-Telemetry\_Vectronic | fix date before deployment                                                                     |     102 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is duplicated, fix date before deployment                                                  |      10 |
| MB-Vita-Elk-Telemetry\_Vectronic | NA                                                                                             |  208239 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is duplicated                                                                              |    5899 |
| MB-Vita-Elk-Telemetry\_Vectronic | status is not 3D                                                                               |     723 |
| MB-Vita-Elk-Telemetry\_Vectronic | long is NA, lat is NA, status is not 3D                                                        |     182 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is duplicated, status is not 3D                                                            |       7 |
| MB-Vita-Elk-Telemetry\_Vectronic | status is not 3D, fix date before deployment                                                   |       1 |
| MB-Vita-Elk-Telemetry\_Vectronic | long is NA, lat is NA, status is not 3D, fix date before deployment                            |       2 |
| MB-Vita-Elk-Telemetry\_Vectronic | long is NA, lat is NA, loc is duplicated, status is not 3D                                     |       3 |
| MB-RMNP-Elk-Telemetry            | NA                                                                                             |   50080 |
| MB-RMNP-Elk-Telemetry            | loc is duplicated                                                                              |      24 |

## Output: column names

| Column name   | Description                                                                  |
|---------------|------------------------------------------------------------------------------|
| id            | unique animal identifier                                                     |
| datetime      | date time in UTC                                                             |
| x\_long       | longitude, EPSG code provided in `metadata()`. see `R/metadata.R`            |
| y\_lat        | latitude, EPSG code provided in `metadata()`. see `R/metadata.R`             |
| flag          | comma separated flags indicating why locs are dropped and set to NaN         |
| doy           | date of year, integer. see `data.table::yday()`                              |
| yr            | year, integer. see `data.table::year()`                                      |
| mnth          | month, integer. see `data.table::month()`                                    |
| x\_proj       | projected x coordinate, output EPSG code in `metadata()`. see `R/metadata.R` |
| y\_proj       | projected y coordinate, output EPSG code in `metadata()`. see `R/metadata.R` |
| epsg\_proj    | output EPSG of ‘x\_proj’ and ‘y\_proj’ as set in `metadata()`.               |
| \[extracols\] | eg. HERD. as provided in the `metadata()`. see `R/metadata.R`                |

## TODO

-   6030 not recognized by PROJ because it’s not a complete CRS..

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
