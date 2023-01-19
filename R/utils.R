
#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
collect <- function(x) {
  UseMethod("collect")
}


#' Title
#'
#' @param d
#'
#' @return
#' @export
#'
#' @examples
collect.hagstofa <- function(d) {
  url <- attr(d, "url")
  variables <- attr(d, "variables")
  variable_names <- names(variables)

  query <- list()

  for (i in seq_along(variable_names)) {

    cur_vars <- variables[[i]]

    keep_vars <- unique(d[[variable_names[i]]])

    query[[variable_names[i]]] <- cur_vars[names(cur_vars) %in% keep_vars] |> unname()

  }


  out <- pxweb::pxweb_get_data(
    url = url,
    query = query
  )

  tibble::as_tibble(out)


}


#' Title
#'
#' @param url
#'
#' @return
#' @export
#'
#' @examples
hg_data <- function(url) {

  url <- url

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
