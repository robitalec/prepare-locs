% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prep_dates.R
\name{prep_dates}
\alias{prep_dates}
\title{Prepare datetime column}
\usage{
prep_dates(DT, tz)
}
\arguments{
\item{tz}{character; time zone of the data \strong{input}, as it is stored the file.}
}
\value{
data.table with datetime in UTC time, idate, itime and DOY
}
\description{
Prepare datetime column
}
\author{
Alec L. Robitaille
}
