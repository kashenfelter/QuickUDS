#'@section Standard descriptive variables (generated by this package):
#'  \describe{
#'
#'  \item{extended_country_name}{The name of the country in the Gleditsch-Ward
#'  system of states, or the official name of the entity (for non-sovereign
#'  entities and states not in the Gleditsch and Ward system of states) or else
#'  a common name for disputed cases that do not have an official name (e.g.,
#'  Western Sahara, Hyderabad). The Gleditsch and Ward scheme sometimes
#'  indicates the common name of the country and (in parentheses) the name of an
#'  earlier incarnation of the state: thus, they have Germany (Prussia), Russia
#'  (Soviet Union), Madagascar (Malagasy), etc. For details, see Gleditsch,
#'  Kristian S. & Michael D. Ward. 1999. "Interstate System Membership: A
#'  Revised List of the Independent States since 1816." International
#'  Interactions 25: 393-413. The list can be found at
#'  \url{http://privatewww.essex.ac.uk/~ksg/statelist.html}.}
#'
#'  \item{GWn}{Gleditsch and Ward's numeric country code, from the Gleditsch and
#'  Ward list of independent states.}
#'
#'  \item{cown}{The Correlates of War numeric country code, 2016 version. This
#'  differs from Gleditsch and Ward's numeric country code in a few cases. See
#'  \url{http://www.correlatesofwar.org/data-sets/state-system-membership} for
#'  the full list.}
#'
#'  \item{polity_ccode}{The Polity IV country code, 2017 version. This
#'  differs from Gleditsch and Ward's numeric country code and COW in a few cases. See
#'  \url{http://www.systemicpeace.org/inscrdata.html} for
#'  the full list.}
#'
#'  \item{in_GW_system}{Whether the state is "in system" (that is, is
#'  independent and sovereign), according to Gleditsch and Ward, for this
#'  particular date. Matches at the end of the year; so, for example South
#'  Vietnam 1975 is \code{FALSE} because, according to Gleditsch and Ward, the
#'  country ended on April 1975 (being absorbed by North Vietnam). It is also
#'  \code{TRUE} for dates beyond 2012 for countries that did not end by then,
#'  depsite the fact that the Gleditsch and Ward list has not been updated
#'  since.}
#'
#'  \item{year}{The calendar year. Democracy measurements conventionally reflect
#'  the situation in the country as of the last day of the year.} }
