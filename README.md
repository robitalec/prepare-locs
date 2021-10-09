prepare-locs
================

-   [Input](#input)
-   [Output](#output)
    -   [Files](#files)
    -   [Column names](#column-names)
    -   [Flag counts](#flag-counts)
-   [TODO](#todo)
-   [Etc](#etc)

------------------------------------------------------------------------

A `targets` workflow for processing animal relocation data for the WEEL.

``` r
library(targets)
```

# Input

Note: this workflow only processes files if it finds them at the
specified path in metadata. This means you can add a row describing your
own input data to `metadata()` and use the workflow, without needing all
other datasets present on your computer.

``` r
tar_read(meta)
```

| path                                                                   | name                             | x\_long   | y\_lat   | id         | datetime  | extracols                                                                | tz  | epsgin     | epsgout | date      | time      | splitBy | deployment                              |
|:-----------------------------------------------------------------------|:---------------------------------|:----------|:---------|:-----------|:----------|:-------------------------------------------------------------------------|:----|:-----------|--------:|:----------|:----------|:--------|:----------------------------------------|
| ../fogo-caribou/data/FogoCaribou.csv                                   | NL-Fogo-Caribou-Telemetry        | X\_COORD  | Y\_COORD | ANIMAL\_ID | datetime  | NA                                                                       | UTC | 4326       |   32621 | NA        | NA        | NA      | NA                                      |
| ../metadata/data/NL/Provincial/Caribou/Telemetry/AllCaribouDataRaw.csv | NL-Provincial-Caribou-Telemetry  | X\_COORD  | Y\_COORD | ANIMAL\_ID | NA        | COLLAR\_TYPE\_CL, HERD , Map\_Quality , EPSG\_CODE , EXCLUDE , DOP , NAV | UTC | EPSG\_CODE |   32621 | FIX\_DATE | FIX\_TIME | HERD    | NA                                      |
| ../metadata/data/NL/Provincial/Lynx/Telemetry/Lynx.csv                 | NL-Provincial-Lynx-Telemetry     | X\_COORD  | Y\_COORD | ANIMAL\_ID | NA        | COLLAR\_TYPE\_CL, HERD , Map\_Quality , EPSG\_CODE , EXCLUDE , DOP , NAV | UTC | EPSG\_CODE |   32621 | FIX\_DATE | FIX\_TIME | HERD    | NA                                      |
| ../metadata/data/NL/Provincial/Bear/Telemetry/Bears.csv                | NL-Provincial-Bear-Telemetry     | X\_COORD  | Y\_COORD | ANIMAL\_ID | NA        | COLLAR\_TYPE\_CL, HERD , Map\_Quality , EPSG\_CODE , EXCLUDE , DOP , NAV | UTC | EPSG\_CODE |   32621 | FIX\_DATE | FIX\_TIME | HERD    | NA                                      |
| ../metadata/data/NL/Provincial/Coyote/Telemetry/Coyote.csv             | NL-Provincial-Coyote-Telemetry   | X\_COORD  | Y\_COORD | ANIMAL\_ID | NA        | COLLAR\_TYPE\_CL, HERD , Map\_Quality , EPSG\_CODE , EXCLUDE , DOP , NAV | UTC | EPSG\_CODE |   32621 | FIX\_DATE | FIX\_TIME | HERD    | NA                                      |
| input/vita\_elk\_lotek\_feb\_2016-july\_2019.csv                       | MB-Vita-Elk-Telemetry\_Lotek     | long      | lat      | animal\_ID | time\_utc | status                                                                   | UTC | 4326       |   32614 | NA        | NA        | NA      | input/vita-elk-lotek-deployment.csv     |
| input/vita\_elk\_vectronic\_feb\_2019-march\_2021.csv                  | MB-Vita-Elk-Telemetry\_Vectronic | long      | lat      | animal\_ID | time\_utc | status                                                                   | UTC | 4326       |   32614 | NA        | NA        | NA      | input/vita-elk-vectronic-deployment.csv |
| input/RMNP\_elk\_2006\_2015.csv                                        | MB-RMNP-Elk-Telemetry            | long      | lat      | EarTag     | DateTime  | NA                                                                       | GMT | 4326       |   32614 | NA        | NA        | NA      | NA                                      |
| ../metadata/data/MB/RMNP/Wolf/Telemetry/Wolf\_combined\_telemetry.csv  | MB-RMNP-Wolf-Telemetry           | longitude | latitude | wolfid     | NA        | Fix2d3d                                                                  | GMT | 4326       |   32614 | gmtdate   | gmttime   | NA      | NA                                      |

# Output

All outputs can be directly read with `data.table::fread` and the
datetime column will be automatically converted to POSIXct in UTC
timezone.

## Files

``` r
tar_read(exports)
```

| name                             | output\_path                                         | n\_rows | split\_by | column\_names                                                                                                |
|:---------------------------------|:-----------------------------------------------------|--------:|:----------|:-------------------------------------------------------------------------------------------------------------|
| NL-Fogo-Caribou-Telemetry        | output/NL-Fogo-Caribou-Telemetry.csv                 |  156006 | NA        | name , id , datetime , x\_long , y\_lat , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj           |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_BUCHANS.csv  |  254028 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_GREY.csv     |  270983 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_GREYVIC.csv  |   11136 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_GROSMORN.csv |   42136 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_LAPOILE.csv  |  247849 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_MIDRIDGE.csv |  389276 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_MTPEYTON.csv |   55030 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_OLDMANS.csv  |   11536 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_POTHILL.csv  |  242091 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_STEPHENV.csv |   44772 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_TOPSAILS.csv |  356426 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Caribou-Telemetry  | output/NL-Provincial-Caribou-Telemetry\_UNKNOWN.csv  |   15818 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Lynx-Telemetry     | output/NL-Provincial-Lynx-Telemetry\_LAPOILE.csv     |    2629 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Lynx-Telemetry     | output/NL-Provincial-Lynx-Telemetry\_MIDRIDGE.csv    |     446 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Lynx-Telemetry     | output/NL-Provincial-Lynx-Telemetry\_NOPENINS.csv    |     102 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Bear-Telemetry     | output/NL-Provincial-Bear-Telemetry\_LAPOILE.csv     |   53262 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Bear-Telemetry     | output/NL-Provincial-Bear-Telemetry\_MIDRIDGE.csv    |   81644 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Bear-Telemetry     | output/NL-Provincial-Bear-Telemetry\_NOPENINS.csv    |   36018 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Coyote-Telemetry   | output/NL-Provincial-Coyote-Telemetry\_LAPOILE.csv   |    4793 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Coyote-Telemetry   | output/NL-Provincial-Coyote-Telemetry\_MIDRIDGE.csv  |    8745 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| NL-Provincial-Coyote-Telemetry   | output/NL-Provincial-Coyote-Telemetry\_NOPENINS.csv  |    6273 | herd      | name , id , datetime , x\_long , y\_lat , herd , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj    |
| MB-Vita-Elk-Telemetry\_Lotek     | output/MB-Vita-Elk-Telemetry\_Lotek.csv              |   10022 | NA        | name , id , datetime , x\_long , y\_lat , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj           |
| MB-Vita-Elk-Telemetry\_Vectronic | output/MB-Vita-Elk-Telemetry\_Vectronic.csv          |  206381 | NA        | name , id , datetime , x\_long , y\_lat , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj           |
| MB-RMNP-Elk-Telemetry            | output/MB-RMNP-Elk-Telemetry.csv                     |   50080 | NA        | name , id , datetime , x\_long , y\_lat , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj           |
| MB-RMNP-Wolf-Telemetry           | output/MB-RMNP-Wolf-Telemetry.csv                    |   32281 | NA        | name , id , datetime , x\_long , y\_lat , fix2d3d , idate , doy , yr , mnth , x\_proj , y\_proj , epsg\_proj |

## Column names

| Column name   | Description                                                                                                                                                   |
|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id            | unique animal identifier                                                                                                                                      |
| datetime      | date time in UTC                                                                                                                                              |
| doy           | date of year, integer. see `data.table::yday()`                                                                                                               |
| mnth          | month, integer. see `data.table::month()`                                                                                                                     |
| yr            | year, integer. see `data.table::year()`                                                                                                                       |
| x\_long       | longitude, EPSG code provided in `metadata()`. see `R/metadata.R`                                                                                             |
| y\_lat        | latitude, EPSG code provided in `metadata()`. see `R/metadata.R`                                                                                              |
| x\_proj       | projected x coordinate, output EPSG code in `metadata()`. see `R/metadata.R`                                                                                  |
| y\_proj       | projected y coordinate, output EPSG code in `metadata()`. see `R/metadata.R`                                                                                  |
| epsg\_proj    | output EPSG of ‘x\_proj’ and ‘y\_proj’ as set in `metadata()`.                                                                                                |
| \[extracols\] | Extras specified in `metadata()`. Eg. HERD. On output, column names are transformed to snake\_case (eg. from ‘HERD’ to ‘herd’ or ‘COLLAR ID’ to ‘collar\_id’) |

In target “checkflags”, the column named “flag” is a semi-colon
separated list of flags indicating why locs are dropped and set to NaN.
After target “filters”, locs with NaN are dropped.

## Flag counts

``` r
tar_read(checkflags)
```

| name                             | flag                                                                                                        |       N |
|:---------------------------------|:------------------------------------------------------------------------------------------------------------|--------:|
| NL-Fogo-Caribou-Telemetry        | NA                                                                                                          |  156006 |
| NL-Fogo-Caribou-Telemetry        | x\_long is NA; y\_lat is NA                                                                                 |    4622 |
| NL-Fogo-Caribou-Telemetry        | x\_long is NA; y\_lat is NA; loc is duplicated                                                              |   34318 |
| NL-Fogo-Caribou-Telemetry        | x\_long is NA; y\_lat is NA; loc is extra                                                                   |       3 |
| NL-Fogo-Caribou-Telemetry        | x\_long is NA; y\_lat is NA; loc is duplicated; loc is extra                                                |      38 |
| NL-Fogo-Caribou-Telemetry        | loc is extra                                                                                                |      13 |
| NL-Fogo-Caribou-Telemetry        | loc is duplicated                                                                                           |       9 |
| NL-Provincial-Caribou-Telemetry  | Collar type is ARGOS                                                                                        |  305866 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N; Collar type is ARGOS                                                                     |    1114 |
| NL-Provincial-Caribou-Telemetry  | Collar type is VHF                                                                                          |   24053 |
| NL-Provincial-Caribou-Telemetry  | loc is duplicated; Collar type is ARGOS                                                                     |      26 |
| NL-Provincial-Caribou-Telemetry  | NA                                                                                                          | 1941081 |
| NL-Provincial-Caribou-Telemetry  | DOP &gt; 10                                                                                                 |    7352 |
| NL-Provincial-Caribou-Telemetry  | NAV is 2D                                                                                                   |   22174 |
| NL-Provincial-Caribou-Telemetry  | x\_long is 0; y\_lat is 0; x\_long == y\_lat; Map\_Quality is N; DOP &gt; 10; NAV is No                     |    4239 |
| NL-Provincial-Caribou-Telemetry  | DOP &gt; 10; NAV is 2D                                                                                      |    1112 |
| NL-Provincial-Caribou-Telemetry  | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; Map\_Quality is N; DOP &gt; 10; NAV is No  |    5746 |
| NL-Provincial-Caribou-Telemetry  | loc is duplicated                                                                                           |     310 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N; NAV is 2D                                                                                |      83 |
| NL-Provincial-Caribou-Telemetry  | x\_long is 0; y\_lat is 0; x\_long == y\_lat; Map\_Quality is N; NAV is No                                  |    2883 |
| NL-Provincial-Caribou-Telemetry  | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; Map\_Quality is N; NAV is No               |    7866 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N; DOP &gt; 10; NAV is 2D                                                                   |      18 |
| NL-Provincial-Caribou-Telemetry  | loc is duplicated; NAV is 2D                                                                                |      58 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N                                                                                           |    8657 |
| NL-Provincial-Caribou-Telemetry  | Map\_Quality is N; DOP &gt; 10                                                                              |      15 |
| NL-Provincial-Caribou-Telemetry  | loc is duplicated; Map\_Quality is N                                                                        |      12 |
| NL-Provincial-Caribou-Telemetry  | loc is extra                                                                                                |       3 |
| NL-Provincial-Lynx-Telemetry     | Collar type is ARGOS                                                                                        |     706 |
| NL-Provincial-Lynx-Telemetry     | loc is duplicated; Collar type is ARGOS                                                                     |      35 |
| NL-Provincial-Lynx-Telemetry     | NA                                                                                                          |    3177 |
| NL-Provincial-Lynx-Telemetry     | Map\_Quality is N                                                                                           |       1 |
| NL-Provincial-Lynx-Telemetry     | NAV is 2D                                                                                                   |     299 |
| NL-Provincial-Lynx-Telemetry     | x\_long is 0; y\_lat is 0; x\_long == y\_lat; Map\_Quality is N; NAV is No                                  |     145 |
| NL-Provincial-Lynx-Telemetry     | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; Map\_Quality is N; NAV is No               |     135 |
| NL-Provincial-Lynx-Telemetry     | DOP &gt; 10; NAV is 2D                                                                                      |       3 |
| NL-Provincial-Lynx-Telemetry     | DOP &gt; 10                                                                                                 |       1 |
| NL-Provincial-Bear-Telemetry     | NA                                                                                                          |  170924 |
| NL-Provincial-Bear-Telemetry     | NAV is 2D                                                                                                   |   12980 |
| NL-Provincial-Bear-Telemetry     | x\_long is 0; y\_lat is 0; x\_long == y\_lat; Map\_Quality is N; DOP &gt; 10; NAV is No                     |   24103 |
| NL-Provincial-Bear-Telemetry     | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; Map\_Quality is N; DOP &gt; 10; NAV is No  |   67286 |
| NL-Provincial-Bear-Telemetry     | x\_long is 0; y\_lat is 0; x\_long == y\_lat; Map\_Quality is N; NAV is No                                  |    2978 |
| NL-Provincial-Bear-Telemetry     | DOP &gt; 10                                                                                                 |    3715 |
| NL-Provincial-Bear-Telemetry     | DOP &gt; 10; NAV is 2D                                                                                      |    1393 |
| NL-Provincial-Bear-Telemetry     | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; Map\_Quality is N; NAV is No               |   10811 |
| NL-Provincial-Bear-Telemetry     | loc is duplicated                                                                                           |      97 |
| NL-Provincial-Bear-Telemetry     | Map\_Quality is N; NAV is 2D                                                                                |       3 |
| NL-Provincial-Bear-Telemetry     | loc is duplicated; NAV is 2D                                                                                |       4 |
| NL-Provincial-Bear-Telemetry     | Map\_Quality is N; DOP &gt; 10; NAV is 2D                                                                   |       1 |
| NL-Provincial-Bear-Telemetry     | loc is duplicated; DOP &gt; 10                                                                              |       1 |
| NL-Provincial-Coyote-Telemetry   | NA                                                                                                          |   19811 |
| NL-Provincial-Coyote-Telemetry   | NAV is 2D                                                                                                   |    1109 |
| NL-Provincial-Coyote-Telemetry   | loc is duplicated                                                                                           |      35 |
| NL-Provincial-Coyote-Telemetry   | x\_long is 0; y\_lat is 0; x\_long == y\_lat; Map\_Quality is N; NAV is No                                  |    1601 |
| NL-Provincial-Coyote-Telemetry   | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; Map\_Quality is N; NAV is No               |    1707 |
| NL-Provincial-Coyote-Telemetry   | NAV is No                                                                                                   |       8 |
| NL-Provincial-Coyote-Telemetry   | DOP &gt; 10                                                                                                 |   69166 |
| NL-Provincial-Coyote-Telemetry   | x\_long is 0; y\_lat is 0; x\_long == y\_lat; Map\_Quality is N; DOP &gt; 10; NAV is 2D                     |    1761 |
| NL-Provincial-Coyote-Telemetry   | DOP &gt; 10; NAV is 2D                                                                                      |    5302 |
| NL-Provincial-Coyote-Telemetry   | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; Map\_Quality is N; DOP &gt; 10; NAV is 2D  |     537 |
| NL-Provincial-Coyote-Telemetry   | loc is duplicated; DOP &gt; 10                                                                              |    3118 |
| NL-Provincial-Coyote-Telemetry   | loc is duplicated; DOP &gt; 10; NAV is 2D                                                                   |     189 |
| NL-Provincial-Coyote-Telemetry   | Map\_Quality is N; DOP &gt; 10                                                                              |      75 |
| NL-Provincial-Coyote-Telemetry   | x\_long is 0; y\_lat is 0; x\_long == y\_lat; Map\_Quality is N; DOP &gt; 10; NAV is No                     |      17 |
| NL-Provincial-Coyote-Telemetry   | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; Map\_Quality is N; DOP &gt; 10; NAV is No  |      17 |
| NL-Provincial-Coyote-Telemetry   | loc is duplicated; NAV is 2D                                                                                |       1 |
| NL-Provincial-Coyote-Telemetry   | Map\_Quality is N; DOP &gt; 10; NAV is 2D                                                                   |       5 |
| NL-Provincial-Coyote-Telemetry   | loc is duplicated; loc is extra                                                                             |       6 |
| NL-Provincial-Coyote-Telemetry   | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; loc is extra; Map\_Quality is N; NAV is No |       1 |
| NL-Provincial-Coyote-Telemetry   | Map\_Quality is N                                                                                           |      25 |
| MB-Vita-Elk-Telemetry\_Lotek     | fix date before deployment                                                                                  |     473 |
| MB-Vita-Elk-Telemetry\_Lotek     | NA                                                                                                          |   10022 |
| MB-Vita-Elk-Telemetry\_Lotek     | x\_long is NA; y\_lat is NA; status is not 3D                                                               |     120 |
| MB-Vita-Elk-Telemetry\_Lotek     | status is not 3D                                                                                            |      22 |
| MB-Vita-Elk-Telemetry\_Lotek     | x\_long is NA; y\_lat is NA; status is not 3D; fix date before deployment                                   |       1 |
| MB-Vita-Elk-Telemetry\_Lotek     | x\_long is NA; y\_lat is NA; loc is duplicated; status is not 3D                                            |       5 |
| MB-Vita-Elk-Telemetry\_Lotek     | loc is duplicated                                                                                           |       2 |
| MB-Vita-Elk-Telemetry\_Vectronic | fix date before deployment                                                                                  |      58 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is extra; fix date before deployment                                                                    |      44 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is duplicated; loc is extra; fix date before deployment                                                 |       7 |
| MB-Vita-Elk-Telemetry\_Vectronic | NA                                                                                                          |  206381 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is duplicated                                                                                           |    4804 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is extra                                                                                                |    1858 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is duplicated; loc is extra                                                                             |    1095 |
| MB-Vita-Elk-Telemetry\_Vectronic | status is not 3D                                                                                            |     723 |
| MB-Vita-Elk-Telemetry\_Vectronic | x\_long is NA; y\_lat is NA; status is not 3D                                                               |     182 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is duplicated; status is not 3D                                                                         |       7 |
| MB-Vita-Elk-Telemetry\_Vectronic | status is not 3D; fix date before deployment                                                                |       1 |
| MB-Vita-Elk-Telemetry\_Vectronic | loc is duplicated; fix date before deployment                                                               |       3 |
| MB-Vita-Elk-Telemetry\_Vectronic | x\_long is NA; y\_lat is NA; status is not 3D; fix date before deployment                                   |       2 |
| MB-Vita-Elk-Telemetry\_Vectronic | x\_long is NA; y\_lat is NA; loc is duplicated; status is not 3D                                            |       3 |
| MB-RMNP-Elk-Telemetry            | NA                                                                                                          |   50080 |
| MB-RMNP-Elk-Telemetry            | loc is duplicated                                                                                           |      24 |
| MB-RMNP-Wolf-Telemetry           | NA                                                                                                          |   32281 |
| MB-RMNP-Wolf-Telemetry           | loc is duplicated                                                                                           |     256 |
| MB-RMNP-Wolf-Telemetry           | loc is extra                                                                                                |   28494 |
| MB-RMNP-Wolf-Telemetry           | x\_long is NA; y\_lat is NA                                                                                 |      35 |
| MB-RMNP-Wolf-Telemetry           | loc is duplicated; loc is extra                                                                             |   61239 |
| MB-RMNP-Wolf-Telemetry           | x\_long is NA; y\_lat is NA; loc is duplicated; loc is extra                                                |     692 |
| MB-RMNP-Wolf-Telemetry           | x\_long is NA; y\_lat is NA; loc is extra                                                                   |       3 |
| MB-RMNP-Wolf-Telemetry           | x\_long is NA; y\_lat is NA; loc is duplicated                                                              |      14 |
| MB-RMNP-Wolf-Telemetry           | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is extra                                                  |      12 |
| MB-RMNP-Wolf-Telemetry           | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated; loc is extra                               |    4216 |
| MB-RMNP-Wolf-Telemetry           | x\_long is 0; y\_lat is 0; x\_long == y\_lat                                                                |     162 |
| MB-RMNP-Wolf-Telemetry           | x\_long is 0; y\_lat is 0; x\_long == y\_lat; loc is duplicated                                             |    2144 |

# TODO

-   6030 not recognized by PROJ because it’s not a complete CRS..

# Etc

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
