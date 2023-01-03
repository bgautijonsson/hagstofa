#' Title
#'
#' @return
#' @export
#'
#' @examples
hg_vinnuafl <- function(verbose = TRUE) {

  url <- "https://px.hagstofa.is:443/pxis/api/v1/is/Samfelag/vinnumarkadur/vinnuaflskraargogn/VIN10052.px"

  query_list <- list(
    "Mánuður" = c("*"),
    "Aldur" = c("*"),
    "Rekstrarform" = c("*"),
    "Kyn" = c("*"),
    "Bakgrunnur" = c("*"),
    "Lögheimili" = c("*")
  )

  px_vars <- pxweb::pxweb_get(url)


  info_table <- tibble::tibble(
    var = px_vars$variables
  ) |>
    tidyr::unnest_wider(var)


  pre_table <- info_table |>
    dplyr::select(text, valueTexts) |>
    tidyr::pivot_wider(names_from = text, values_from = valueTexts)

  pre_table_code <- info_table |>
    dplyr::select(code, values) |>
    tidyr::pivot_wider(names_from = code, values_from = values)


  n_cols <- ncol(pre_table)
  var_names <- names(pre_table)
  var_values <- list()
  out <- tibble::tibble(value = 1)

  variable_names <- info_table$code
  names(variable_names) <- info_table$text

  variables <- list()



  for (i in seq_len(n_cols)) {
    temp <- tibble::tibble(pre_table[, var_names[i], drop = T][[1]])
    names(temp) <- var_names[i]

    variables[[variable_names[i]]] <- pre_table_code[, variable_names[i], drop = T][[1]]
    names(variables[[variable_names[i]]]) <-pre_table[, var_names[i], drop = T][[1]]

    out <- tidyr::crossing(
      out,
      temp
    )
  }

  out$value <- NULL

  attr(out, "url") <- url
  attr(out, "variables") <- variables
  class(out) <- c("hagstofa", class(out))

  out
}





