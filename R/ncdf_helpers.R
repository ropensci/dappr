# get metadata and data -----------------------
ncdf4_get <- function(file){
  nc <- ncdf4::nc_open(file)
  tmp <- unclass(nc)

  dims <- names(nc$dim)
  out <- list()
  for (i in seq_along(dims)) {
    out[[dims[i]]] <- ncdf4::ncvar_get(nc, nc$dim[[dims[i]]])
  }
  out$time <- sapply(out$time, convert_time)
  vars <- names(nc$var)
  outvars <- list()
  for (i in seq_along(vars)) {
    outvars[[ vars[i] ]] <- as.vector(ncdf4::ncvar_get(nc, vars[i]))
  }
  df <- do.call("cbind.data.frame", outvars)
  rows <- length(outvars[[1]])
  out <- lapply(out, function(z) rep(z, each = rows/length(z)))
  meta <- data.frame(out, stringsAsFactors = FALSE)
  alldf <- cbind(meta, df)
  on.exit(ncdf4::nc_close(nc))
  list(summary = tmp, data = alldf)
}

ncdf4_summary <- function(file){
  nc <- ncdf4::nc_open(file, readunlim = FALSE)
  tmp <- unclass(nc)
  on.exit(ncdf4::nc_close(nc))
  list(summary = tmp, data = data.frame(NULL))
}
