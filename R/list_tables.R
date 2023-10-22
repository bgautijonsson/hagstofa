#' Get an interactive view of all available table from Hagstofa Íslands
#'
#' @return A searchable table made with the {gt} package
#' @export
hg_list_tables <- function() {
  url <- "https://raw.githubusercontent.com/bgautijonsson/hagstofa_scraping/master/data/tables.csv"
  readr::read_csv(url) |>
    gt::gt() |>
    gt::cols_label(
      name = "Nafn",
      last_update = "Síðast uppfært",
      url = "Vefslóð",
      path = "Gagnaslóð"
    ) |>
    gt::opt_interactive(
      use_search = T
    )
}
