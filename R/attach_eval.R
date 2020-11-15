#' Evaluate R expressions in an attached environment.
#'
#' @param unquoted_expr The expression to be evaluated, This is automatically
#'   quoted.
#' @param name The environment name. If an environment of that name already
#'   exists, it is reused, otherwise, a new environment is attached.
#' @param pos The position where to attach the environment, if creating a new
#'   one. If an environment of `name` already exists, `pos` is ignored.
#' @param warn.conflicts logical. If TRUE (the default), print warnings about
#'   objects in the attached environment that that are masking or masked by
#'   other objects of the same name.
#' @param ... Ignored.
#' @param mask.ok character vector of names of objects that can mask objects on
#'   the search path without signaling a warning if `warn.conflicts` is `TRUE`
#' @param expr A R language object. This is an escape hatch from the automatic
#'   quoting of `unquoted_expr`.
#'
#' @return the attached environment, invisibly.
#' @export
#'
#' @examples
#' attach_eval({
#'   my_helper_funct <- function(x, y) x + y
#' })
#'
#' search() # environment "local:utils" is now attached
#' my_helper_funct(1, 1) # the local utility is now available
#'
#' detach(local:utils) # cleanup
attach_eval <- function(unquoted_expr, name = "local:utils", pos = 2L,
                        warn.conflicts = TRUE, ...,
                        expr = substitute(unquoted_expr),
                        mask.ok = NULL) {

  if (...length())
    stop("Arguments after `...` must be named")

  envir <- get_attached_env(name)

  if (warn.conflicts)
    mask.ok <- c(mask.ok, names(envir))

  eval(expr, envir)

  if (warn.conflicts)
    warn_about_conflicts(envir, ignore = mask.ok)
  invisible(envir)
}