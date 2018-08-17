#' Returns ratings, entities, and households rated by PD by rating level in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' breakdown_by_rating(from = 20170701, to = 20180630)

breakdown_by_rating <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  breakdown_by_rating_query <- getcdw::parameterize_template("sql/breakdown-by-rating-query.sql")
  getcdw::get_cdw(breakdown_by_rating_query(from = from, to = to))
}
