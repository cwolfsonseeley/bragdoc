#' Returns class year (by decade) of prospects rated by PD in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' class_year(from = 20170701, to = 20180630)

class_year <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  class_year_query <- getcdw::parameterize_template("sql/class-year-query.sql")
  result <- getcdw::get_cdw(class_year_query(from = from, to = to))
  result$pref_class_year <- as.numeric(result$pref_class_year)
  result <- dplyr::filter(result, pref_class_year > 1)
  result <- dplyr::mutate(result, decade = paste0(substr(pref_class_year,1,3),0))
  dplyr::summarise(dplyr::group_by(result, decade), n_entities = sum(n_entities))
}

