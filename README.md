
# prepare-locs

A `targets` workflow for processing animal relocation data from the
WEEL.

``` r
targets::tar_visnetwork()
```

![](README_files/figure-gfm/viz-1.png)<!-- -->

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
