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

| path                                                                   | name                            | x_long    | y_lat    | id        | datetime  | extracols                                                            | tz  | epsgin    | epsgout | date     | time     | splitBy | deployment                              |
|:-----------------------------------------------------------------------|:--------------------------------|:----------|:---------|:----------|:----------|:---------------------------------------------------------------------|:----|:----------|--------:|:---------|:---------|:--------|:----------------------------------------|
| ../metadata/data/NL/Fogo-Island/Caribou/Telemetry/FogoCaribou.csv      | NL-Fogo-Caribou-Telemetry       | X_COORD   | Y_COORD  | ANIMAL_ID | datetime  | NA                                                                   | UTC | 4326      |   32621 | NA       | NA       | NA      | NA                                      |
| ../metadata/data/NL/Provincial/Caribou/Telemetry/AllCaribouDataRaw.csv | NL-Provincial-Caribou-Telemetry | X_COORD   | Y_COORD  | ANIMAL_ID | NA        | COLLAR_TYPE_CL, HERD , Map_Quality , EPSG_CODE , EXCLUDE , DOP , NAV | UTC | EPSG_CODE |   32621 | FIX_DATE | FIX_TIME | HERD    | NA                                      |
| ../metadata/data/NL/Provincial/Lynx/Telemetry/Lynx.csv                 | NL-Provincial-Lynx-Telemetry    | X_COORD   | Y_COORD  | ANIMAL_ID | NA        | COLLAR_TYPE_CL, HERD , Map_Quality , EPSG_CODE , EXCLUDE , DOP , NAV | UTC | EPSG_CODE |   32621 | FIX_DATE | FIX_TIME | HERD    | NA                                      |
| ../metadata/data/NL/Provincial/Bear/Telemetry/Bears.csv                | NL-Provincial-Bear-Telemetry    | X_COORD   | Y_COORD  | ANIMAL_ID | NA        | COLLAR_TYPE_CL, HERD , Map_Quality , EPSG_CODE , EXCLUDE , DOP , NAV | UTC | EPSG_CODE |   32621 | FIX_DATE | FIX_TIME | HERD    | NA                                      |
| ../metadata/data/NL/Provincial/Coyote/Telemetry/Coyote.csv             | NL-Provincial-Coyote-Telemetry  | X_COORD   | Y_COORD  | ANIMAL_ID | NA        | COLLAR_TYPE_CL, HERD , Map_Quality , EPSG_CODE , EXCLUDE , DOP , NAV | UTC | EPSG_CODE |   32621 | FIX_DATE | FIX_TIME | HERD    | NA                                      |
| input/vita_elk_lotek_feb_2016-july_2019.csv                            | MB-Vita-Elk-Telemetry_Lotek     | long      | lat      | animal_ID | time_utc  | status                                                               | UTC | 4326      |   32614 | NA       | NA       | NA      | input/vita-elk-lotek-deployment.csv     |
| input/vita_elk_vectronic_feb_2019-march_2021.csv                       | MB-Vita-Elk-Telemetry_Vectronic | long      | lat      | animal_ID | time_utc  | status                                                               | UTC | 4326      |   32614 | NA       | NA       | NA      | input/vita-elk-vectronic-deployment.csv |
| ../metadata/data/MB/RMNP/Elk/Telemetry/MB_RMNP_Elk_Telemetry.csv       | MB-RMNP-Elk-Telemetry           | long      | lat      | ElkID     | date_time | NA                                                                   | GMT | 4326      |   32614 | NA       | NA       | NA      | NA                                      |
| ../metadata/data/MB/RMNP/Wolf/Telemetry/MB_RMNP_Wolf_Telemetry.csv     | MB-RMNP-Wolf-Telemetry          | longitude | latitude | wolfid    | NA        | Fix2d3d                                                              | GMT | 4326      |   32614 | gmtdate  | gmttime  | NA      | NA                                      |

# Output

All outputs can be directly read with `data.table::fread` and the
datetime column will be automatically converted to POSIXct in UTC
timezone.

## Files

``` r
tar_read(exports)
```

| name                            | output_path                                         | n_rows | split_by | column_names                                                                                            |
|:--------------------------------|:----------------------------------------------------|-------:|:---------|:--------------------------------------------------------------------------------------------------------|
| NL-Fogo-Caribou-Telemetry       | output/NL-Fogo-Caribou-Telemetry.csv                | 229865 | NA       | name , id , datetime , x_long , y_lat , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj           |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_BUCHANS.csv  | 254028 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_GREY.csv     | 270983 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_GREYVIC.csv  |  11136 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_GROSMORN.csv |  42136 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_LAPOILE.csv  | 247849 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_MIDRIDGE.csv | 389276 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_MTPEYTON.csv |  55030 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_OLDMANS.csv  |  11536 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_POTHILL.csv  | 242091 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_STEPHENV.csv |  44772 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_TOPSAILS.csv | 356426 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Caribou-Telemetry | output/NL-Provincial-Caribou-Telemetry_UNKNOWN.csv  |  15818 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Lynx-Telemetry    | output/NL-Provincial-Lynx-Telemetry_LAPOILE.csv     |   2629 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Lynx-Telemetry    | output/NL-Provincial-Lynx-Telemetry_MIDRIDGE.csv    |    446 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Lynx-Telemetry    | output/NL-Provincial-Lynx-Telemetry_NOPENINS.csv    |    102 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Bear-Telemetry    | output/NL-Provincial-Bear-Telemetry_LAPOILE.csv     |  53262 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Bear-Telemetry    | output/NL-Provincial-Bear-Telemetry_MIDRIDGE.csv    |  81644 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Bear-Telemetry    | output/NL-Provincial-Bear-Telemetry_NOPENINS.csv    |  36018 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Coyote-Telemetry  | output/NL-Provincial-Coyote-Telemetry_LAPOILE.csv   |   4793 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Coyote-Telemetry  | output/NL-Provincial-Coyote-Telemetry_MIDRIDGE.csv  |   8745 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| NL-Provincial-Coyote-Telemetry  | output/NL-Provincial-Coyote-Telemetry_NOPENINS.csv  |   6273 | herd     | name , id , datetime , x_long , y_lat , herd , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj    |
| MB-Vita-Elk-Telemetry_Lotek     | output/MB-Vita-Elk-Telemetry_Lotek.csv              |  10022 | NA       | name , id , datetime , x_long , y_lat , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj           |
| MB-Vita-Elk-Telemetry_Vectronic | output/MB-Vita-Elk-Telemetry_Vectronic.csv          | 206381 | NA       | name , id , datetime , x_long , y_lat , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj           |
| MB-RMNP-Elk-Telemetry           | output/MB-RMNP-Elk-Telemetry.csv                    |  98928 | NA       | name , id , datetime , x_long , y_lat , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj           |
| MB-RMNP-Wolf-Telemetry          | output/MB-RMNP-Wolf-Telemetry.csv                   |  32266 | NA       | name , id , datetime , x_long , y_lat , fix2d3d , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj |

## Column names

| Column name   | Description                                                                                                                                                 |
|---------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id            | unique animal identifier                                                                                                                                    |
| datetime      | date time in UTC                                                                                                                                            |
| doy           | date of year, integer. see `data.table::yday()`                                                                                                             |
| mnth          | month, integer. see `data.table::month()`                                                                                                                   |
| yr            | year, integer. see `data.table::year()`                                                                                                                     |
| x_long        | longitude, EPSG code provided in `metadata()`. see `R/metadata.R`                                                                                           |
| y_lat         | latitude, EPSG code provided in `metadata()`. see `R/metadata.R`                                                                                            |
| x_proj        | projected x coordinate, output EPSG code in `metadata()`. see `R/metadata.R`                                                                                |
| y_proj        | projected y coordinate, output EPSG code in `metadata()`. see `R/metadata.R`                                                                                |
| epsg_proj     | output EPSG of ‘x_proj’ and ‘y_proj’ as set in `metadata()`.                                                                                                |
| \[extracols\] | Extras specified in `metadata()`. Eg. HERD. On output, column names are transformed to snake_case (eg. from ‘HERD’ to ‘herd’ or ‘COLLAR ID’ to ‘collar_id’) |

In target “checkflags”, the column named “flag” is a semi-colon
separated list of flags indicating why locs are dropped and set to NaN.
After target “filters”, locs with NaN are dropped.

## Flag counts

``` r
tar_read(checkflags)
```

| name                            | flag                                                                                                   |       N |
|:--------------------------------|:-------------------------------------------------------------------------------------------------------|--------:|
| NL-Fogo-Caribou-Telemetry       | NA                                                                                                     |  229865 |
| NL-Fogo-Caribou-Telemetry       | loc is duplicated                                                                                      |     105 |
| NL-Fogo-Caribou-Telemetry       | loc is extra                                                                                           |      53 |
| NL-Provincial-Caribou-Telemetry | Collar type is ARGOS                                                                                   |  305866 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N; Collar type is ARGOS                                                                 |    1114 |
| NL-Provincial-Caribou-Telemetry | Collar type is VHF                                                                                     |   24053 |
| NL-Provincial-Caribou-Telemetry | loc is duplicated; Collar type is ARGOS                                                                |      26 |
| NL-Provincial-Caribou-Telemetry | NA                                                                                                     | 1941081 |
| NL-Provincial-Caribou-Telemetry | DOP \> 10                                                                                              |    7352 |
| NL-Provincial-Caribou-Telemetry | NAV is 2D                                                                                              |   22174 |
| NL-Provincial-Caribou-Telemetry | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; DOP \> 10; NAV is No                       |    4239 |
| NL-Provincial-Caribou-Telemetry | DOP \> 10; NAV is 2D                                                                                   |    1112 |
| NL-Provincial-Caribou-Telemetry | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; Map_Quality is N; DOP \> 10; NAV is No    |    5746 |
| NL-Provincial-Caribou-Telemetry | loc is duplicated                                                                                      |     310 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N; NAV is 2D                                                                            |      83 |
| NL-Provincial-Caribou-Telemetry | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; NAV is No                                  |    2883 |
| NL-Provincial-Caribou-Telemetry | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; Map_Quality is N; NAV is No               |    7866 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N; DOP \> 10; NAV is 2D                                                                 |      18 |
| NL-Provincial-Caribou-Telemetry | loc is duplicated; NAV is 2D                                                                           |      58 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N                                                                                       |    8657 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N; DOP \> 10                                                                            |      15 |
| NL-Provincial-Caribou-Telemetry | loc is duplicated; Map_Quality is N                                                                    |      12 |
| NL-Provincial-Caribou-Telemetry | loc is extra                                                                                           |       3 |
| NL-Provincial-Lynx-Telemetry    | Collar type is ARGOS                                                                                   |     706 |
| NL-Provincial-Lynx-Telemetry    | loc is duplicated; Collar type is ARGOS                                                                |      35 |
| NL-Provincial-Lynx-Telemetry    | NA                                                                                                     |    3177 |
| NL-Provincial-Lynx-Telemetry    | Map_Quality is N                                                                                       |       1 |
| NL-Provincial-Lynx-Telemetry    | NAV is 2D                                                                                              |     299 |
| NL-Provincial-Lynx-Telemetry    | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; NAV is No                                  |     145 |
| NL-Provincial-Lynx-Telemetry    | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; Map_Quality is N; NAV is No               |     135 |
| NL-Provincial-Lynx-Telemetry    | DOP \> 10; NAV is 2D                                                                                   |       3 |
| NL-Provincial-Lynx-Telemetry    | DOP \> 10                                                                                              |       1 |
| NL-Provincial-Bear-Telemetry    | NA                                                                                                     |  170924 |
| NL-Provincial-Bear-Telemetry    | NAV is 2D                                                                                              |   12980 |
| NL-Provincial-Bear-Telemetry    | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; DOP \> 10; NAV is No                       |   24103 |
| NL-Provincial-Bear-Telemetry    | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; Map_Quality is N; DOP \> 10; NAV is No    |   67286 |
| NL-Provincial-Bear-Telemetry    | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; NAV is No                                  |    2978 |
| NL-Provincial-Bear-Telemetry    | DOP \> 10                                                                                              |    3715 |
| NL-Provincial-Bear-Telemetry    | DOP \> 10; NAV is 2D                                                                                   |    1393 |
| NL-Provincial-Bear-Telemetry    | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; Map_Quality is N; NAV is No               |   10811 |
| NL-Provincial-Bear-Telemetry    | loc is duplicated                                                                                      |      97 |
| NL-Provincial-Bear-Telemetry    | Map_Quality is N; NAV is 2D                                                                            |       3 |
| NL-Provincial-Bear-Telemetry    | loc is duplicated; NAV is 2D                                                                           |       4 |
| NL-Provincial-Bear-Telemetry    | Map_Quality is N; DOP \> 10; NAV is 2D                                                                 |       1 |
| NL-Provincial-Bear-Telemetry    | loc is duplicated; DOP \> 10                                                                           |       1 |
| NL-Provincial-Coyote-Telemetry  | NA                                                                                                     |   19811 |
| NL-Provincial-Coyote-Telemetry  | NAV is 2D                                                                                              |    1109 |
| NL-Provincial-Coyote-Telemetry  | loc is duplicated                                                                                      |      35 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; NAV is No                                  |    1601 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; Map_Quality is N; NAV is No               |    1707 |
| NL-Provincial-Coyote-Telemetry  | NAV is No                                                                                              |       8 |
| NL-Provincial-Coyote-Telemetry  | DOP \> 10                                                                                              |   69166 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; DOP \> 10; NAV is 2D                       |    1761 |
| NL-Provincial-Coyote-Telemetry  | DOP \> 10; NAV is 2D                                                                                   |    5302 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; Map_Quality is N; DOP \> 10; NAV is 2D    |     537 |
| NL-Provincial-Coyote-Telemetry  | loc is duplicated; DOP \> 10                                                                           |    3118 |
| NL-Provincial-Coyote-Telemetry  | loc is duplicated; DOP \> 10; NAV is 2D                                                                |     189 |
| NL-Provincial-Coyote-Telemetry  | Map_Quality is N; DOP \> 10                                                                            |      75 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; DOP \> 10; NAV is No                       |      17 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; Map_Quality is N; DOP \> 10; NAV is No    |      17 |
| NL-Provincial-Coyote-Telemetry  | loc is duplicated; NAV is 2D                                                                           |       1 |
| NL-Provincial-Coyote-Telemetry  | Map_Quality is N; DOP \> 10; NAV is 2D                                                                 |       5 |
| NL-Provincial-Coyote-Telemetry  | loc is duplicated; loc is extra                                                                        |       6 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; Map_Quality is N; NAV is No |       1 |
| NL-Provincial-Coyote-Telemetry  | Map_Quality is N                                                                                       |      25 |
| MB-Vita-Elk-Telemetry_Lotek     | fix date before deployment                                                                             |     473 |
| MB-Vita-Elk-Telemetry_Lotek     | NA                                                                                                     |   10022 |
| MB-Vita-Elk-Telemetry_Lotek     | x_long is NA; y_lat is NA; status is not 3D                                                            |     120 |
| MB-Vita-Elk-Telemetry_Lotek     | status is not 3D                                                                                       |      22 |
| MB-Vita-Elk-Telemetry_Lotek     | x_long is NA; y_lat is NA; status is not 3D; fix date before deployment                                |       1 |
| MB-Vita-Elk-Telemetry_Lotek     | x_long is NA; y_lat is NA; loc is duplicated; status is not 3D                                         |       5 |
| MB-Vita-Elk-Telemetry_Lotek     | loc is duplicated                                                                                      |       2 |
| MB-Vita-Elk-Telemetry_Vectronic | fix date before deployment                                                                             |      58 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is extra; fix date before deployment                                                               |      44 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is duplicated; loc is extra; fix date before deployment                                            |       7 |
| MB-Vita-Elk-Telemetry_Vectronic | NA                                                                                                     |  206381 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is duplicated                                                                                      |    4804 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is extra                                                                                           |    1858 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is duplicated; loc is extra                                                                        |    1095 |
| MB-Vita-Elk-Telemetry_Vectronic | status is not 3D                                                                                       |     723 |
| MB-Vita-Elk-Telemetry_Vectronic | x_long is NA; y_lat is NA; status is not 3D                                                            |     182 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is duplicated; status is not 3D                                                                    |       7 |
| MB-Vita-Elk-Telemetry_Vectronic | status is not 3D; fix date before deployment                                                           |       1 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is duplicated; fix date before deployment                                                          |       3 |
| MB-Vita-Elk-Telemetry_Vectronic | x_long is NA; y_lat is NA; status is not 3D; fix date before deployment                                |       2 |
| MB-Vita-Elk-Telemetry_Vectronic | x_long is NA; y_lat is NA; loc is duplicated; status is not 3D                                         |       3 |
| MB-RMNP-Elk-Telemetry           | NA                                                                                                     |   98928 |
| MB-RMNP-Elk-Telemetry           | loc is duplicated                                                                                      |      79 |
| MB-RMNP-Elk-Telemetry           | loc is duplicated; loc is extra                                                                        |       2 |
| MB-RMNP-Elk-Telemetry           | loc is extra                                                                                           |       2 |
| MB-RMNP-Wolf-Telemetry          | NA                                                                                                     |   32266 |
| MB-RMNP-Wolf-Telemetry          | loc is duplicated                                                                                      |     256 |
| MB-RMNP-Wolf-Telemetry          | loc is extra                                                                                           |      23 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA; datetime is NA                                                              |       1 |
| MB-RMNP-Wolf-Telemetry          | datetime is NA; loc is extra                                                                           |   28471 |
| MB-RMNP-Wolf-Telemetry          | loc is duplicated; datetime is NA; loc is extra                                                        |   57284 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA; loc is duplicated; datetime is NA; loc is extra                             |     968 |
| MB-RMNP-Wolf-Telemetry          | datetime is NA                                                                                         |      15 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA; datetime is NA; loc is extra                                                |       3 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA                                                                              |      34 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA; loc is duplicated                                                           |      14 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat; datetime is NA; loc is extra                                 |      12 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; datetime is NA; loc is extra              |    2823 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat                                                               |     162 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated                                            |    2144 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra                              |    4660 |
| MB-RMNP-Wolf-Telemetry          | loc is duplicated; loc is extra                                                                        |   65090 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA; loc is duplicated; loc is extra                                             |      96 |

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
