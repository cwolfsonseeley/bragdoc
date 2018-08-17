#' Returns development officers supported and number of proposals created for each DO in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' proposals_created(from = 20170701, to = 20180630)

proposals_created <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  proposals_created_query <- getcdw::parameterize_template("sql/dos-units-supported.sql")
  getcdw::get_cdw(proposals_created_query(from = from, to = to))

}


#' Returns units supported and number of development officers in each unit in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' units_supported(from = 20170701, to = 20180630)

units_supported <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  units_supported_query <- getcdw::parameterize_template("sql/dos-units-supported.sql")
  results <- getcdw::get_cdw(units_supported_query(from = from, to = to))
  dplyr::summarise(group_by(results, unit), development_officers = n_distinct(development_officer))

}

#' Returns sum of development officers and units supported in given timeframe.
#'
#' @param from Start date, in yyyymmdd format
#' @param to End date, in yyyymmdd format
#' @export
#' @examples
#' total_units_supported(from = 20170701, to = 20180630)

total_units_supported <- function(from, to) {
  if (!assertthat::is.count(from))
    stop(from, " is not a valid date")
  if (!assertthat::is.count(to))
    stop(to, " is not a valid date")

  units_supported_query <- getcdw::parameterize_template("sql/dos-units-supported.sql")
  results <- getcdw::get_cdw(units_supported_query(from = from, to = to))
  results <- dplyr::summarise(group_by(results, unit), development_officers = n_distinct(development_officer))
  data.frame(development_officers_supported=sum(results$development_officers),
             units_supported=dplyr::n_distinct(results$unit))

}
