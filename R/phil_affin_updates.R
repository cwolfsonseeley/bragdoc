#' Returns philanthropic affinities added by PD by fiscal year in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' phil_affin_updates(from = 20170701, to = 20180630)

phil_affin_updates <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  phil_affin_updates_query <- getcdw::parameterize_template("sql/phil-affin-updates-query.sql")
  getcdw::get_cdw(phil_affin_updates_query(from = from, to = to))
}
