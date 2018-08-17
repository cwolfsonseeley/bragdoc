#' Returns ratings, entities, households rated, and capacity identified (in dollars) by PD by fiscal year in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' capacity_identified(from = 20150701, to = 20180630)

capacity_identified <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  cap_id_query <- getcdw::parameterize_template("sql/capacity-identified-query.sql")
  getcdw::get_cdw(cap_id_query(from = from, to = to))
}

