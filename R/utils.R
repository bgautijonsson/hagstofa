
#' Define the method collect that we use to download hagstofa objects
#'
#' @param x
#'
#' @return
#' @export
collect <- function(x, ...) {
  dplyr::collect(x, ...)
}


#' Download a specified hagstofa object
#'
#' @param d A hagstofa object defined using hg_data(url)
#'
#' @return Returns a tibble containing the data
collect.hagstofa <- function(d) {
  data_size <- nrow(d)
  if (data_size > 5000) {
    out <- download_large_data(d)
  } else {
    out <- download_data(d)
  }

  out
}

#' Download a hagstofa object that contains < 5000 lines of results
#'
#' @param d A hagstofa object defined using hg_data(url)
#'
#' @return Returns a tibble containing the data
download_data <- function(d) {
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

#' Download a hagstofa object that would give > 5000 lines.
#'
#' The data is downloaded by finding which variable uses the least amount of sub-queries and makes all sub-queries return < 5000 lines.
#'
#' @param A hagstofa object defined using hg_data(url)
#'
#' @return Returns a tibble containing the data
download_large_data <- function(d) {
  data_size <- nrow(d)
  unique_values <- apply(
    d,
    2,
    \(x) length(unique(x))
  )
  grouped_data_size <- data_size / unique_values
  usable_columns <- grouped_data_size[grouped_data_size <= 5000]
  split_var <- names(usable_columns[usable_columns == max(usable_columns)][1])
  split_values <- unique(d[[split_var]])
  out <- list()
  for (i in seq_along(split_values)) {
    temp_d <- d[d[[split_var]] == split_values[i], ]
    out[[i]] <- download_data(temp_d)
  }

  dplyr::bind_rows(out)
}


#' Use a URL for a table from Hagstofa Íslands to create an object of type hagstofa that can be filtered before downloading data
#'
#' @param url The URL for a table from Hagstofa Íslands.
#'
#' @return Returns a tibble-like object of class hagstofa that can be filtered before using collect() to download data
#' @export
hg_data <- function(url) {

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
    names(variables[[variable_names[i]]]) <- pre_table[, var_names[i], drop = T][[1]]

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
