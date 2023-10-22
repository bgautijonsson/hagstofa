#' Get an interactive view of all available table from Hagstofa Íslands
#'
#' @return A searchable table made with the {gt} package
#' @export
hg_list_tables <- function() {
  url <- "https://raw.githubusercontent.com/bgautijonsson/hagstofa_scraping/master/data/tables.csv"
  readr::read_csv(url, show_col_types = FALSE, progress = FALSE) |>
    gt::gt() |>
    gt::cols_label(
      name = "Nafn",
      last_update = "Síðast uppfært",
      url = "Vefslóð fyrir hg_data",
      path = "Geymsluslóð"
    ) |>
    gt::opt_interactive(
      use_search = T
    )
}
