#' @name sprinkle_round
#' @title Sprinkle Appearance of NA's
#' 
#' @description The appearance of \code{NA} values in a table may be dependent
#'   on the context.  \code{pixiedust} uses the \code{round} sprinkle
#'   to guide the appearance of missing values in the table.
#'   
#' @param x An object of class \code{dust}
#' @param rows Either a numeric vector of rows in the tabular object to be 
#'   modified or an object of class \code{call}.  When a \code{call}, 
#'   generated by \code{quote(expression)}, the expression resolves to 
#'   a logical vector the same length as the number of rows in the table.
#'   Sprinkles are applied to where the expression resolves to \code{TRUE}.
#' @param cols Either a numeric vector of columns in the tabular object to
#'   be modified, or a character vector of column names. A mixture of 
#'   character and numeric indices is permissible.
#' @param round \code{numeric(1)} A value to pass to the \code{digits}
#'   argument of \code{\link{round}}.
#' @param part A character string denoting which part of the table to modify.
#' @param fixed \code{logical(1)} indicating if the values in \code{rows} 
#'   and \code{cols} should be read as fixed coordinate pairs.  By default, 
#'   sprinkles are applied at the intersection of \code{rows} and \code{cols}, 
#'   meaning that the arguments do not have to share the same length.  
#'   When \code{fixed = TRUE}, they must share the same length.
#' @param recycle A \code{character} one that determines how sprinkles are 
#'   managed when the sprinkle input doesn't match the length of the region
#'   to be sprinkled.  By default, recycling is turned off.  Recycling 
#'   may be performed across rows first (left to right, top to bottom), 
#'   or down columns first (top to bottom, left to right).
#' @param ... Additional arguments to pass to other methods. Currently ignored.
#' 
#' @section Functional Requirements:
#' \enumerate{
#'  \item Correctly reassigns the appropriate elements \code{round} column
#'    in the table part.
#'  \item Casts an error if \code{x} is not a \code{dust} object.
#'  \item Casts an error if \code{round} is not a \code{numeric(1)}
#'  \item Casts an error if \code{part} is not one of \code{"body"}, 
#'    \code{"head"}, \code{"foot"}, or \code{"interfoot"}
#'  \item Casts an error if \code{fixed} is not a \code{logical(1)}
#'  \item Casts an error if \code{recycle} is not one of \code{"none"},
#'    \code{"rows"}, or \code{"cols"}
#' }
#' 
#' The functional behavior of the \code{fixed} and \code{recycle} arguments 
#' is not tested for this function. It is tested and validated in the
#' tests for \code{\link{index_to_sprinkle}}.
#' 
#' @seealso \code{\link{sprinkle}}, 
#'   \code{\link{index_to_sprinkle}}
#'
#' @export

sprinkle_round <- function(x, rows = NULL, cols = NULL,
                               round = NULL, 
                               part = c("body", "head", "foot", "interfoot"),
                               fixed = FALSE, 
                               recycle = c("none", "rows", "cols", "columns"),
                               ...)
{
  UseMethod("sprinkle_round")
}

#' @rdname sprinkle_round
#' @export

sprinkle_round.default <- function(x, rows = NULL, cols = NULL,
                                       round = NULL, 
                                       part = c("body", "head", "foot", "interfoot"),
                                       fixed = FALSE, 
                                       recycle = c("none", "rows", "cols", "columns"),
                                       ...)
{
  coll <- checkmate::makeAssertCollection()
  
  if (!is.null(round))
  {
    checkmate::assert_integerish(x = round,
                                 len = 1,
                                 add = coll)
  }
  
  indices <- index_to_sprinkle(x = x, 
                               rows = rows, 
                               cols = cols, 
                               fixed = fixed,
                               part = part,
                               recycle = recycle,
                               coll = coll)
  
  checkmate::reportAssertions(coll)
  
  # At this point, part should have passed the assertions in 
  # index_to_sprinkle. The first element is expected to be valid.
  
  part <- part[1]
  
  x[[part]][["round"]][indices] <- round
  
  x
}

#' @rdname sprinkle_round
#' @export

sprinkle_round.dust_list <- function(x, rows = NULL, cols = NULL,
                                         round = NULL, 
                                         part = c("body", "head", "foot", "interfoot"),
                                         fixed = FALSE, 
                                         recycle = c("none", "rows", "cols", "columns"),
                                         ...)
{
  structure(
    lapply(X = x,
           FUN = sprinkle_round.default,
           rows = rows,
           cols = cols,
           round = round,
           part = part,
           fixed = fixed,
           recycle = recycle,
           ...),
    class = "dust_list"
  )
}

# Unexported Utility ------------------------------------------------

# These functions are to be used inside of the general `sprinkle` call
# When used inside `sprinkle`, the indices are already determined, 
# the only the `round` argument needs to be validated. 
# The assert function is kept separate so it may be called earlier
# without attempting to perform the assignment.

sprinkle_round_index_assert <- function(round, coll)
{
  if (!is.null(round))
  {
    checkmate::assert_character(x = round,
                                len = 1,
                                add = coll,
                                .var.name = "round")
  }
}

sprinkle_round_index <- function(x, indices, round, part)
{
  x[[part]][["round"]][indices] <- round
  
  x
}