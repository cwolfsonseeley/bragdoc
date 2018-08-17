#' Returns median and average rating by fiscal year in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' median_rating(from = 20150701, to = 20180630)

median_rating <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  median_rating_query <- getcdw::parameterize_template("sql/median-rating-query.sql")
  result <- getcdw::get_cdw(median_rating_query(from = from, to = to))
  result$rating_code <- as.numeric(result$rating_code)
  result %>%
    filter(rating_code != 96, !is.na(rating_code)) %>%
    group_by(evaluation_fy) %>%
    summarise(median_ratng = median(rating_code), average_rating = mean(rating_code))

}
