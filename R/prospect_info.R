#' Returns rated households, percentage of those households contacted in past year,
# past five years, or ever, percentage of those households with an active major gift proposal,
# percentage of those households that ever had a major gift proposal, and percentage of those
# households with a primary manager in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' prospect_info(from = 20170701, to = 20180630)

prospect_info <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  prospect_info_query <- getcdw::parameterize_template("sql/prospect-info-query.sql")
  results <- getcdw::get_cdw(prospect_info_query(from = from, to = to))
  results <- dplyr::mutate(results, contacted_within_one_year = contacted_within_one_year/rated_households)
  results <- dplyr::mutate(results, contacted_within_five_years = contacted_within_five_years/rated_households)
  results <- dplyr::mutate(results, contacted_more_than_five_years = contacted_more_than_five_years/rated_households)
  results <- dplyr::mutate(results, active_major_gift_proposal = active_major_gift_proposal/rated_households)
  results <- dplyr::mutate(results, inactive_major_gift_proposal = inactive_major_gift_proposal/rated_households)
  dplyr::mutate(results, primary_manager = primary_manager/rated_households)
}

