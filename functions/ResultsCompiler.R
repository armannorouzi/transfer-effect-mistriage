#' ResultsCompiler
#'
#' Uses data.sets with local mistriage data combines this with comparison data to create
#' a results data frame.
#' Vectors used: Data set, sample, imputation, local mistriage, transfer mistriage, difference.
#'
#' @param data.sets A list.
#' @param comparison.data. A list.
ResultsCompiler <- function(list.of.data.sets, comparison.data){
  
  ## Error handling

  ## Single out local mistriage values with corresponding imputation
  local.mistriage <- lapply(list.of.data.sets, function(sample) lapply(sample, function(imp) (lapply(imp, function(x) {
    imputation <- median(x[[2]][[1]])
    local.mistriage <- x[[7]]
    x <- data.frame(imputation, local.mistriage)
    })))) 
  ## Combine all imputations to one data frame in each sample
  combined.by.imp <- lapply(local.mistriage, function(sample) lapply(sample, function(df) {
    df1 <- df[[1]]
    for (x in 2:length(df)) {
      df1 <- merge(df1, df[[x]], all = TRUE)
    }
      return(df1)
      }))
  ##  Single out transfer mistriage value
  transfer.mistriage <- lapply(comparison.data, function(sample) lapply(sample, function(imp) (lapply(imp, function(x) {
    transfer.mistriage <- x[[1]]
    x <- data.frame(transfer.mistriage)
  })))) 
  ## Combine to one data frame in each sample
  combined.transfer <- lapply(transfer.mistriage, function(sample) lapply(sample, function(df) {
    df1 <- df[[1]]
    for (x in 2:length(df)) {
      df1 <- merge(df1, df[[x]], all = TRUE, sort = FALSE)
    }
    return(df1)
  }))
  ## Combine local mistriage and transfer mistriage into one dataframe per sample
  for (i in 1:length(combined.by.imp)) {
    for (u in 1:length(combined.by.imp[[i]])) {
      combined.by.imp[[i]][[u]] <- cbind(combined.by.imp[[i]][[u]], combined.transfer[[i]][[u]])
    }
  }
  
  ## Calculate difference, local performance vs transferred performance of local model
  results.with.diff <- lapply(combined.by.imp, function(sample) lapply(sample, function(x) {
    x$transfer.performance.minus.local.performance <- x[[3]] - x[[2]]
    return(x)
    }))
  ## Calculate difference, local performance vs transferred model, transferred model performance minus local model performance
  all.results.with.diff <- lapply(results.with.diff, function(x) {
    x[[1]]$transferred.performance.minus.buddy.local.performance <- x[[1]][[3]] - x[[2]][[2]]
    x[[2]]$transferred.performance.minus.buddy.local.performance <- x[[2]][[3]] - x[[1]][[2]]
    return(x)
  })
  
  ## Create output
  output <- all.results.with.diff
  ## Return output
  return(output)
}
