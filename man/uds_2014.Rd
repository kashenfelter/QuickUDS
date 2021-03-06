% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/uds_documentation.R
\docType{data}
\name{uds_2014}
\alias{uds_2014}
\alias{uds}
\alias{uds_2011}
\alias{uds_2010}
\title{The Unified Democracy Scores}
\format{An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 9850 rows and 12 columns.}
\usage{
uds_2014

uds_2011

uds_2010
}
\description{
The 2014, 2011, and 2010 releases of the Unified Democracy Scores by
Pemstein, Meserve, and Melton (2010).
}
\details{
\describe{

\item{uds_country}{The name of the country in the UDS release}

\item{uds_cowcode}{The correlates of war numeric code, as in the original UDS
release. This is different from the actual COW code in a few cases; it looks
like they were using GW codes instead of COW codes. Use the \code{cown}
variable instead for merging with COW-indexed data.}

\item{mean}{The posterior mean of the latent variable in the UD release.}

\item{sd}{The posterior standard deviation of the latent variable in the UD
release.}

\item{median}{The posterior median of the latent variable in the UD release.}

\item{pct025}{Unified democracy score posterior 2.5 percentile.}

\item{pct975}{Unified democracy score posterior 97.5 percentile.} }
}
\section{Standard descriptive variables (generated by this package)}{

 \describe{

 \item{extended_country_name}{The name of the country in the Gleditsch-Ward
 system of states, or the official name of the entity (for non-sovereign
 entities and states not in the Gleditsch and Ward system of states) or else
 a common name for disputed cases that do not have an official name (e.g.,
 Western Sahara, Hyderabad). The Gleditsch and Ward scheme sometimes
 indicates the common name of the country and (in parentheses) the name of an
 earlier incarnation of the state: thus, they have Germany (Prussia), Russia
 (Soviet Union), Madagascar (Malagasy), etc. For details, see Gleditsch,
 Kristian S. & Michael D. Ward. 1999. "Interstate System Membership: A
 Revised List of the Independent States since 1816." International
 Interactions 25: 393-413. The list can be found at
 \url{http://privatewww.essex.ac.uk/~ksg/statelist.html}.}

 \item{GWn}{Gleditsch and Ward's numeric country code, from the Gleditsch and
 Ward list of independent states.}

 \item{cown}{The Correlates of War numeric country code, 2016 version. This
 differs from Gleditsch and Ward's numeric country code in a few cases. See
 \url{http://www.correlatesofwar.org/data-sets/state-system-membership} for
 the full list.}

 \item{polity_ccode}{The Polity IV country code, 2017 version. This
 differs from Gleditsch and Ward's numeric country code and COW in a few cases. See
 \url{http://www.systemicpeace.org/inscrdata.html} for
 the full list.}

 \item{in_GW_system}{Whether the state is "in system" (that is, is
 independent and sovereign), according to Gleditsch and Ward, for this
 particular date. Matches at the end of the year; so, for example South
 Vietnam 1975 is \code{FALSE} because, according to Gleditsch and Ward, the
 country ended on April 1975 (being absorbed by North Vietnam). It is also
 \code{TRUE} for dates beyond 2012 for countries that did not end by then,
 depsite the fact that the Gleditsch and Ward list has not been updated
 since.}

 \item{year}{The calendar year. Democracy measurements conventionally reflect
 the situation in the country as of the last day of the year.} }
}

\references{
Pemstein, Daniel, Stephen Meserve, and James Melton. 2010.
Democratic Compromise: A Latent Variable Analysis of Ten Measures of Regime
Type. Political Analysis 18 (4): 426-449.

Pemstein, Daniel, Stephen A. Meserve, and James Melton. 2013. "Replication
data for: Democratic Compromise: A Latent Variable Analysis of Ten Measures
of Regime Type." In: Harvard Dataverse.
\url{http://hdl.handle.net/1902.1/PMM}
}
\seealso{
Other democracy: \code{\link{democracy}},
  \code{\link{extended_uds}}
}
\keyword{datasets}
