#' Returns number of international households in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' international_households(from = 20150701, to = 20180630)

international_households <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  international_households_query <- getcdw::parameterize_template("sql/international-households.sql")
  getcdw::get_cdw(international_households_query(from = from, to = to))
}
