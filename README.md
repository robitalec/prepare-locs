prepare-locs
================

- [Input](#input)
- [Output](#output)
  - [Files](#files)
  - [Column names](#column-names)
  - [Flag counts](#flag-counts)
- [TODO](#todo)
- [Etc](#etc)

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

| path                                                                   | name                            | x_long    | y_lat    | id        | date     | time     | extracols                                                            | extracols_names                      | deployment                                  | tz  | epsgin | epsgout | splitBy | datetime  |
|:-----------------------------------------------------------------------|:--------------------------------|:----------|:---------|:----------|:---------|:---------|:---------------------------------------------------------------------|:-------------------------------------|:--------------------------------------------|:----|-------:|--------:|:--------|:----------|
| ../metadata/data/NL/Fogo-Island/Caribou/Telemetry                      | NL-Fogo-Caribou-Telemetry       | V10       | V9       | id        | V2       | V3       | filename , V13 , V12 , collar_id                                     | filename , FixType , DOP , collar_id | input/2023-09-22_Fogo-collar-deployment.csv | UTC |   4326 |   32621 | NA      | NA        |
| ../metadata/data/NL/Provincial/Caribou/Telemetry/AllCaribouDataRaw.csv | NL-Provincial-Caribou-Telemetry | X_COORD   | Y_COORD  | ANIMAL_ID | FIX_DATE | FIX_TIME | COLLAR_TYPE_CL, HERD , Map_Quality , EPSG_CODE , EXCLUDE , DOP , NAV | NULL                                 | NA                                          | UTC |   4326 |   32621 | HERD    | NA        |
| ../metadata/data/NL/Provincial/Lynx/Telemetry/Lynx.csv                 | NL-Provincial-Lynx-Telemetry    | X_COORD   | Y_COORD  | ANIMAL_ID | FIX_DATE | FIX_TIME | COLLAR_TYPE_CL, HERD , Map_Quality , EPSG_CODE , EXCLUDE , DOP , NAV | NULL                                 | NA                                          | UTC |   4326 |   32621 | HERD    | NA        |
| ../metadata/data/NL/Provincial/Bear/Telemetry/Bears.csv                | NL-Provincial-Bear-Telemetry    | X_COORD   | Y_COORD  | ANIMAL_ID | FIX_DATE | FIX_TIME | COLLAR_TYPE_CL, HERD , Map_Quality , EPSG_CODE , EXCLUDE , DOP , NAV | NULL                                 | NA                                          | UTC |   4326 |   32621 | HERD    | NA        |
| ../metadata/data/NL/Provincial/Coyote/Telemetry/Coyote.csv             | NL-Provincial-Coyote-Telemetry  | X_COORD   | Y_COORD  | ANIMAL_ID | FIX_DATE | FIX_TIME | COLLAR_TYPE_CL, HERD , Map_Quality , EPSG_CODE , EXCLUDE , DOP , NAV | NULL                                 | NA                                          | UTC |   4326 |   32621 | HERD    | NA        |
| input/vita_elk_lotek_feb_2016-july_2019.csv                            | MB-Vita-Elk-Telemetry_Lotek     | long      | lat      | animal_ID | NA       | NA       | status                                                               | NULL                                 | input/vita-elk-lotek-deployment.csv         | UTC |   4326 |   32614 | NA      | time_utc  |
| input/vita_elk_vectronic_feb_2019-march_2021.csv                       | MB-Vita-Elk-Telemetry_Vectronic | long      | lat      | animal_ID | NA       | NA       | status                                                               | NULL                                 | input/vita-elk-vectronic-deployment.csv     | UTC |   4326 |   32614 | NA      | time_utc  |
| ../metadata/data/MB/RMNP/Elk/Telemetry/MB_RMNP_Elk_Telemetry.csv       | MB-RMNP-Elk-Telemetry           | long      | lat      | ElkID     | NA       | NA       | NA                                                                   | NULL                                 | NA                                          | GMT |   4326 |   32614 | NA      | date_time |
| ../metadata/data/MB/RMNP/Wolf/Telemetry/MB_RMNP_Wolf_Telemetry.csv     | MB-RMNP-Wolf-Telemetry          | longitude | latitude | wolfid    | gmtdate  | gmttime  | Fix2d3d                                                              | NULL                                 | NA                                          | GMT |   4326 |   32614 | NA      | NA        |

# Output

All outputs can be directly read with `data.table::fread` and the
datetime column will be automatically converted to POSIXct in UTC
timezone.

## Files

``` r
tar_read(exports)
```

| name                            | output_path                                                    | n_rows | split_by | column_names                                                                                                        |
|:--------------------------------|:---------------------------------------------------------------|-------:|:---------|:--------------------------------------------------------------------------------------------------------------------|
| NL-Fogo-Caribou-Telemetry       | output/2024-01-26_NL-Fogo-Caribou-Telemetry.csv                | 218957 | NA       | name , id , datetime , x_long , y_lat , filename , collar_id, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_BUCHANS.csv  | 254052 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_GREY.csv     | 271015 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_GREYVIC.csv  |  11139 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_GROSMORN.csv |  42208 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_LAPOILE.csv  | 247869 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_MIDRIDGE.csv | 389385 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_MTPEYTON.csv |  55030 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_OLDMANS.csv  |  11540 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_POTHILL.csv  | 242107 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_STEPHENV.csv |  44774 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_TOPSAILS.csv | 356454 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Caribou-Telemetry | output/2024-01-25_NL-Provincial-Caribou-Telemetry_UNKNOWN.csv  |  15818 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Lynx-Telemetry    | output/2024-01-25_NL-Provincial-Lynx-Telemetry_LAPOILE.csv     |   2629 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Lynx-Telemetry    | output/2024-01-25_NL-Provincial-Lynx-Telemetry_MIDRIDGE.csv    |    446 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Lynx-Telemetry    | output/2024-01-25_NL-Provincial-Lynx-Telemetry_NOPENINS.csv    |    102 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Bear-Telemetry    | output/2024-01-25_NL-Provincial-Bear-Telemetry_LAPOILE.csv     |  53280 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Bear-Telemetry    | output/2024-01-25_NL-Provincial-Bear-Telemetry_MIDRIDGE.csv    |  81702 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Bear-Telemetry    | output/2024-01-25_NL-Provincial-Bear-Telemetry_NOPENINS.csv    |  36039 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Coyote-Telemetry  | output/2024-01-25_NL-Provincial-Coyote-Telemetry_LAPOILE.csv   |   4796 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Coyote-Telemetry  | output/2024-01-25_NL-Provincial-Coyote-Telemetry_MIDRIDGE.csv  |   8776 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| NL-Provincial-Coyote-Telemetry  | output/2024-01-25_NL-Provincial-Coyote-Telemetry_NOPENINS.csv  |   6274 | herd     | name , id , datetime , x_long , y_lat , herd , epsg_code, idate , doy , yr , mnth , x_proj , y_proj , epsg_proj     |
| MB-Vita-Elk-Telemetry_Lotek     | output/2024-01-26_MB-Vita-Elk-Telemetry_Lotek.csv              |   9986 | NA       | name , id , datetime , x_long , y_lat , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj                       |
| MB-Vita-Elk-Telemetry_Vectronic | output/2024-01-26_MB-Vita-Elk-Telemetry_Vectronic.csv          | 211142 | NA       | name , id , datetime , x_long , y_lat , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj                       |
| MB-RMNP-Elk-Telemetry           | output/2024-01-25_MB-RMNP-Elk-Telemetry.csv                    |  99007 | NA       | name , id , datetime , x_long , y_lat , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj                       |
| MB-RMNP-Wolf-Telemetry          | output/2024-01-25_MB-RMNP-Wolf-Telemetry.csv                   |  32522 | NA       | name , id , datetime , x_long , y_lat , fix2d3d , idate , doy , yr , mnth , x_proj , y_proj , epsg_proj             |

## Column names

| Column name   | Description                                                                                                                                                 |
|---------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id            | unique animal identifier                                                                                                                                    |
| datetime      | date time in UTC                                                                                                                                            |
| doy           | day of year, integer. see `data.table::yday()`                                                                                                              |
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
tar_read(checkflags)[order(name, -N)]
```

| name                            | flag                                                                                                                                   |       N |
|:--------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------|--------:|
| MB-RMNP-Elk-Telemetry           | NA                                                                                                                                     |   99007 |
| MB-RMNP-Elk-Telemetry           | loc is duplicated; loc is extra                                                                                                        |       2 |
| MB-RMNP-Elk-Telemetry           | loc is extra                                                                                                                           |       2 |
| MB-RMNP-Wolf-Telemetry          | loc is duplicated; loc is extra                                                                                                        |   65090 |
| MB-RMNP-Wolf-Telemetry          | loc is duplicated; datetime is NA; loc is extra                                                                                        |   57284 |
| MB-RMNP-Wolf-Telemetry          | NA                                                                                                                                     |   32522 |
| MB-RMNP-Wolf-Telemetry          | datetime is NA; loc is extra                                                                                                           |   28471 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra                                                              |    4657 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; datetime is NA; loc is extra                                              |    2823 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat                                                                                               |    2306 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA; loc is duplicated; datetime is NA; loc is extra                                                             |     968 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA; loc is duplicated; loc is extra                                                                             |      96 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA                                                                                                              |      48 |
| MB-RMNP-Wolf-Telemetry          | loc is extra                                                                                                                           |      23 |
| MB-RMNP-Wolf-Telemetry          | datetime is NA                                                                                                                         |      15 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat; datetime is NA; loc is extra                                                                 |      12 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA; datetime is NA; loc is extra                                                                                |       3 |
| MB-RMNP-Wolf-Telemetry          | x_long is 0; y_lat is 0; x_long == y_lat; loc is extra                                                                                 |       3 |
| MB-RMNP-Wolf-Telemetry          | x_long is NA; y_lat is NA; datetime is NA                                                                                              |       1 |
| MB-Vita-Elk-Telemetry_Lotek     | NA                                                                                                                                     |    9986 |
| MB-Vita-Elk-Telemetry_Lotek     | loc is before first deployment                                                                                                         |     510 |
| MB-Vita-Elk-Telemetry_Lotek     | x_long is NA; y_lat is NA; status is not 3D                                                                                            |     121 |
| MB-Vita-Elk-Telemetry_Lotek     | status is not 3D                                                                                                                       |      22 |
| MB-Vita-Elk-Telemetry_Lotek     | x_long is NA; y_lat is NA; status is not 3D; loc is before first deployment                                                            |       4 |
| MB-Vita-Elk-Telemetry_Lotek     | loc is after last deployment                                                                                                           |       1 |
| MB-Vita-Elk-Telemetry_Lotek     | x_long is NA; y_lat is NA; status is not 3D; loc is after last deployment                                                              |       1 |
| MB-Vita-Elk-Telemetry_Vectronic | NA                                                                                                                                     |  211142 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is extra                                                                                                                           |    2431 |
| MB-Vita-Elk-Telemetry_Vectronic | status is not 3D                                                                                                                       |     728 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is duplicated; loc is extra                                                                                                        |     450 |
| MB-Vita-Elk-Telemetry_Vectronic | x_long is NA; y_lat is NA; status is not 3D                                                                                            |     185 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is extra; loc is before first deployment                                                                                           |     112 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is before first deployment                                                                                                         |     104 |
| MB-Vita-Elk-Telemetry_Vectronic | loc is duplicated; loc is extra; loc is before first deployment                                                                        |      11 |
| MB-Vita-Elk-Telemetry_Vectronic | status is not 3D; loc is before first deployment                                                                                       |       3 |
| MB-Vita-Elk-Telemetry_Vectronic | x_long is NA; y_lat is NA; status is not 3D; loc is before first deployment                                                            |       2 |
| NL-Fogo-Caribou-Telemetry       | NA                                                                                                                                     |  218957 |
| NL-Fogo-Caribou-Telemetry       | loc is duplicated; loc is extra                                                                                                        |  132907 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; FixType is No                                                                                               |   32409 |
| NL-Fogo-Caribou-Telemetry       | loc has NA id, likely outside deployment                                                                                               |   11743 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is duplicated; loc is extra; FixType is No                                                              |    8334 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; DOP \> 10; FixType is No                                                                                    |    7992 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; FixType is No; loc has NA id, likely outside deployment                                                     |    5187 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is duplicated; loc is extra; DOP \> 10; FixType is No                                                   |    3631 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; loc has NA id, likely outside deployment                                                                                 |    2595 |
| NL-Fogo-Caribou-Telemetry       | FixType is 2D                                                                                                                          |    2484 |
| NL-Fogo-Caribou-Telemetry       | loc is duplicated; loc is extra; FixType is 2D                                                                                         |    2203 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; FixType is No; loc has NA id, likely outside deployment                                       |    1009 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10                                                                                                                              |     888 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; FixType is No Fix; loc has NA id, likely outside deployment                                                 |     751 |
| NL-Fogo-Caribou-Telemetry       | loc is duplicated; loc is extra; DOP \> 10                                                                                             |     741 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; DOP \> 10; FixType is No Fix; loc has NA id, likely outside deployment                                      |     720 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; FixType is No; loc is after last deployment                                                                 |     429 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; FixType is No Fix; loc has NA id, likely outside deployment                                   |     387 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; DOP \> 10; FixType is No; loc has NA id, likely outside deployment                                          |     344 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; FixType is No; loc is before first deployment                                                               |     336 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; FixType is 2D                                                                                                               |     279 |
| NL-Fogo-Caribou-Telemetry       | loc is duplicated; loc is extra; DOP \> 10; FixType is 2D                                                                              |     272 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; DOP \> 10; loc is before first deployment                   |     211 |
| NL-Fogo-Caribou-Telemetry       | FixType is GPS-2D; loc has NA id, likely outside deployment                                                                            |     181 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is duplicated; loc is extra; FixType is No; loc is before first deployment                              |     173 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is duplicated; loc is extra; FixType is No; loc has NA id, likely outside deployment                    |     142 |
| NL-Fogo-Caribou-Telemetry       | loc is after last deployment                                                                                                           |     103 |
| NL-Fogo-Caribou-Telemetry       | FixType is 2D; loc has NA id, likely outside deployment                                                                                |      95 |
| NL-Fogo-Caribou-Telemetry       | loc is before first deployment                                                                                                         |      88 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; DOP \> 10; FixType is No; loc has NA id, likely outside deployment                            |      85 |
| NL-Fogo-Caribou-Telemetry       | FixType is GPS-2D                                                                                                                      |      76 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; FixType is No Fix                                                                                           |      76 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; DOP \> 10; loc is before first deployment                                                                                |      62 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; loc has NA id, likely outside deployment                                                                                    |      61 |
| NL-Fogo-Caribou-Telemetry       | loc is duplicated; loc is extra; loc has NA id, likely outside deployment                                                              |      61 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; loc is before first deployment                                                                                              |      60 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; DOP \> 10; FixType is No; loc is before first deployment                                                    |      44 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; DOP \> 10; FixType is NoNav; loc is before first deployment                                                              |      41 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; loc is after last deployment                                                                                                |      40 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; DOP \> 10; loc is before first deployment                                                    |      39 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; FixType is No; loc is before first deployment                                                 |      38 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; DOP \> 10; FixType is No Fix                                                                                |      38 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; loc is before first deployment                              |      35 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is duplicated; loc is extra; DOP \> 10; FixType is No; loc has NA id, likely outside deployment         |      34 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; DOP \> 10; FixType is NoNav; loc is before first deployment                                  |      34 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; DOP \> 10; FixType is No; loc is after last deployment                                                      |      33 |
| NL-Fogo-Caribou-Telemetry       | loc is duplicated; loc is extra; loc is before first deployment                                                                        |      33 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; DOP \> 10; loc is after last deployment                                                                                  |      29 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; FixType is No; loc is after last deployment                                                   |      29 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; DOP \> 10; FixType is No Fix; loc has NA id, likely outside deployment                        |      24 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; FixType is 2D; loc has NA id, likely outside deployment                                                                  |      23 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; FixType is NoNav; loc is before first deployment                                                                            |      20 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; DOP \> 10; loc is after last deployment                                                      |      19 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; DOP \> 10; FixType is 2D; loc is before first deployment                                                                 |      18 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; loc is before first deployment                                                                                           |      14 |
| NL-Fogo-Caribou-Telemetry       | loc is duplicated; loc is extra; loc is after last deployment                                                                          |      12 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is after last deployment                                                                 |      11 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; DOP \> 10; FixType is NoNav; loc is after last deployment                                                                |      11 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; FixType is GPS-2D; loc has NA id, likely outside deployment                                                                 |      11 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is duplicated; loc is extra; DOP \> 10; FixType is No; loc is before first deployment                   |      10 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is duplicated; loc is extra; DOP \> 10; FixType is No; loc is after last deployment                     |      10 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; FixType is 2D; loc has NA id, likely outside deployment                                                                     |       9 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; DOP \> 10; FixType is NoNav; loc is after last deployment                                    |       9 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; FixType is GPS-2D; loc has NA id, likely outside deployment                                                              |       9 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; FixType is No                                                                                 |       8 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; FixType is NoNav; loc is after last deployment                                                                              |       8 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; DOP \> 10; FixType is 2D; loc is before first deployment                                     |       8 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; DOP \> 10; FixType is 2D; loc is after last deployment                                       |       7 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; FixType is 2D; loc is after last deployment                                                                                 |       7 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is before first deployment                                                               |       7 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; DOP \> 10; FixType is 2D; loc is after last deployment                                                                   |       7 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; DOP \> 10; FixType is No; loc is after last deployment                                        |       7 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; DOP \> 10; FixType is No; loc is before first deployment                                      |       6 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; loc is after last deployment                                                                                             |       5 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is duplicated; loc is extra; FixType is No; loc is after last deployment                                |       5 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; DOP \> 10; loc has NA id, likely outside deployment                                                                      |       4 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; FixType is NoNav; loc is before first deployment                                             |       4 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; DOP \> 10; FixType is NoNav                                                                  |       4 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; FixType is 2D; loc is before first deployment                                                                            |       4 |
| NL-Fogo-Caribou-Telemetry       | FixType is NoNav; loc is before first deployment                                                                                       |       4 |
| NL-Fogo-Caribou-Telemetry       | FixType is NoNav; loc is after last deployment                                                                                         |       4 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; FixType is NoNav; loc is before first deployment                                                                         |       4 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; DOP \> 10; FixType is NoNav; loc is after last deployment   |       4 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; DOP \> 10; FixType is NoNav; loc is before first deployment |       4 |
| NL-Fogo-Caribou-Telemetry       | loc is extra                                                                                                                           |       4 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; FixType is GPS-2D                                                                                                           |       4 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; DOP \> 10; loc is after last deployment                     |       3 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; FixType is 2D; loc is after last deployment                                                  |       3 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; DOP \> 10                                                   |       3 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; loc is after last deployment                                |       3 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; DOP \> 10; FixType is 2D; loc has NA id, likely outside deployment                                                       |       2 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is extra; DOP \> 10; loc is before first deployment                                      |       2 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; FixType is NoNav; loc is after last deployment                                               |       2 |
| NL-Fogo-Caribou-Telemetry       | FixType is 2D; loc is before first deployment                                                                                          |       2 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; FixType is 2D; loc is before first deployment                                                                               |       2 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; DOP \> 10; FixType is 2D; loc is after last deployment      |       2 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; FixType is NoNav; loc is after last deployment              |       2 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is extra; DOP \> 10; loc is after last deployment                                        |       2 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat                                                                                               |       1 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; FixType is 2D; loc is before first deployment                                                |       1 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; FixType is NoNav; loc is after last deployment                                                                           |       1 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; FixType is 2D                                                                                |       1 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; DOP \> 10                                                                                    |       1 |
| NL-Fogo-Caribou-Telemetry       | x_long is NA; y_lat is NA; loc is extra; DOP \> 10; FixType is No                                                                      |       1 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is extra; loc is before first deployment                                                 |       1 |
| NL-Fogo-Caribou-Telemetry       | DOP \> 10; FixType is NoNav                                                                                                            |       1 |
| NL-Fogo-Caribou-Telemetry       | FixType is 2D; loc is after last deployment                                                                                            |       1 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; DOP \> 10; FixType is 2D; loc is before first deployment    |       1 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; DOP \> 10; FixType is 2D                                                                     |       1 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; DOP \> 10; FixType is NoNav                                 |       1 |
| NL-Fogo-Caribou-Telemetry       | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; FixType is NoNav; loc is before first deployment            |       1 |
| NL-Fogo-Caribou-Telemetry       | loc is extra; DOP \> 10; FixType is GPS-2D; loc has NA id, likely outside deployment                                                   |       1 |
| NL-Provincial-Bear-Telemetry    | NA                                                                                                                                     |  171021 |
| NL-Provincial-Bear-Telemetry    | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; DOP \> 10; NAV is No                                                       |   91389 |
| NL-Provincial-Bear-Telemetry    | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; NAV is No                                                                  |   13789 |
| NL-Provincial-Bear-Telemetry    | NAV is 2D                                                                                                                              |   12984 |
| NL-Provincial-Bear-Telemetry    | DOP \> 10                                                                                                                              |    3716 |
| NL-Provincial-Bear-Telemetry    | DOP \> 10; NAV is 2D                                                                                                                   |    1393 |
| NL-Provincial-Bear-Telemetry    | Map_Quality is N; NAV is 2D                                                                                                            |       3 |
| NL-Provincial-Bear-Telemetry    | Map_Quality is N; DOP \> 10; NAV is 2D                                                                                                 |       1 |
| NL-Provincial-Caribou-Telemetry | NA                                                                                                                                     | 1941391 |
| NL-Provincial-Caribou-Telemetry | Collar type is ARGOS                                                                                                                   |  305892 |
| NL-Provincial-Caribou-Telemetry | Collar type is VHF                                                                                                                     |   24053 |
| NL-Provincial-Caribou-Telemetry | NAV is 2D                                                                                                                              |   22232 |
| NL-Provincial-Caribou-Telemetry | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; NAV is No                                                                  |   10749 |
| NL-Provincial-Caribou-Telemetry | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; DOP \> 10; NAV is No                                                       |    9985 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N                                                                                                                       |    8669 |
| NL-Provincial-Caribou-Telemetry | DOP \> 10                                                                                                                              |    7352 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N; Collar type is ARGOS                                                                                                 |    1114 |
| NL-Provincial-Caribou-Telemetry | DOP \> 10; NAV is 2D                                                                                                                   |    1112 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N; NAV is 2D                                                                                                            |      83 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N; DOP \> 10; NAV is 2D                                                                                                 |      18 |
| NL-Provincial-Caribou-Telemetry | Map_Quality is N; DOP \> 10                                                                                                            |      15 |
| NL-Provincial-Caribou-Telemetry | loc is extra                                                                                                                           |       3 |
| NL-Provincial-Coyote-Telemetry  | DOP \> 10                                                                                                                              |   72284 |
| NL-Provincial-Coyote-Telemetry  | NA                                                                                                                                     |   19846 |
| NL-Provincial-Coyote-Telemetry  | DOP \> 10; NAV is 2D                                                                                                                   |    5491 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; NAV is No                                                                  |    3308 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; DOP \> 10; NAV is 2D                                                       |    2298 |
| NL-Provincial-Coyote-Telemetry  | NAV is 2D                                                                                                                              |    1110 |
| NL-Provincial-Coyote-Telemetry  | Map_Quality is N; DOP \> 10                                                                                                            |      75 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; DOP \> 10; NAV is No                                                       |      34 |
| NL-Provincial-Coyote-Telemetry  | Map_Quality is N                                                                                                                       |      25 |
| NL-Provincial-Coyote-Telemetry  | NAV is No                                                                                                                              |       8 |
| NL-Provincial-Coyote-Telemetry  | loc is duplicated; loc is extra                                                                                                        |       6 |
| NL-Provincial-Coyote-Telemetry  | Map_Quality is N; DOP \> 10; NAV is 2D                                                                                                 |       5 |
| NL-Provincial-Coyote-Telemetry  | x_long is 0; y_lat is 0; x_long == y_lat; loc is duplicated; loc is extra; Map_Quality is N; NAV is No                                 |       1 |
| NL-Provincial-Lynx-Telemetry    | NA                                                                                                                                     |    3177 |
| NL-Provincial-Lynx-Telemetry    | Collar type is ARGOS                                                                                                                   |     741 |
| NL-Provincial-Lynx-Telemetry    | NAV is 2D                                                                                                                              |     299 |
| NL-Provincial-Lynx-Telemetry    | x_long is 0; y_lat is 0; x_long == y_lat; Map_Quality is N; NAV is No                                                                  |     280 |
| NL-Provincial-Lynx-Telemetry    | DOP \> 10; NAV is 2D                                                                                                                   |       3 |
| NL-Provincial-Lynx-Telemetry    | Map_Quality is N                                                                                                                       |       1 |
| NL-Provincial-Lynx-Telemetry    | DOP \> 10                                                                                                                              |       1 |

# TODO

- 6030 not recognized by PROJ because it’s not a complete CRS..

# Etc

Screening GPS fixes:

- <https://ropensci.github.io/CoordinateCleaner/articles/Comparison_other_software.html>
  - missing coordinates
  - lat == 0
  - long == 0
  - lat == long
  - …
- *Effects of habitat on GPS collar performance: using data screening to
  reduce location error*. Lewis et al. 2007
  - drop 2D fixes
  - threshold PDOP
- *Screening GPS telemetry data for locations having unacceptable
  error*. Laver et al. 
