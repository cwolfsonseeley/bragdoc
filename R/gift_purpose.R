#' Returns top n gift purposes for rated prospects and number of gifts made in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @param n_purpose Number of gift purposes to return
#' @export
#' @examples
#' gift_purpose(from = 20170701, to = 20180630, n_purpose = 5)

gift_purpose <- function(from, to, n_purpose) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  gift_purpose_query <- getcdw::parameterize_template("sql/gift-purpose-query.sql")
  getcdw::get_cdw(gift_purpose_query(from = from, to = to, n_purpose = n_purpose))
}
