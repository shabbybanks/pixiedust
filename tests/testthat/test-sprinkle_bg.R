context("sprinkle_bg")

x <- dust(head(mtcars))

# Functional Requirement 1 ------------------------------------------

test_that(
  "Correctly reassigns the appropriate elements bg column in the table part.",
  {
    bg <- rep("", nrow(x$body))
    bg[x$body$row == 1] <- "red"
    expect_equal(
      sprinkle_bg(x, rows = 1, bg = "red")$body$bg,
      bg
    )
  }
)

test_that(
  "Correctly reassigns the appropriate elements bg column in the table part.",
  {
    bg <- rep("", nrow(x$body))
    bg[x$body$row == 2 & x$body$col %in% 4:5] <- "blue"
    expect_equal(
      sprinkle_bg(x, rows = 2, cols = 4:5, bg = "blue")$body$bg,
      bg
    )
  }
)

test_that(
  "Correctly reassigns the appropriate elements bg column in the table part.",
  {
    bg <- rep("", nrow(x$body))
    bg[x$body$row == 2 & x$body$col %in% 4:5] <- "transparent"
    expect_equal(
      sprinkle_bg(x, rows = c(2, 2), cols = 4:5, bg = "transparent",
                  fixed = TRUE)$body$bg,
      bg
    )
  }
)

# Functional Requirement 2 ------------------------------------------

test_that(
  "Casts an error if x is not a dust object.",
  {
    expect_error(sprinkle_bg(mtcars))
  }
)

# Functional Requirement 3 ------------------------------------------

test_that(
  "Casts an error if bg is not a character(1)",
  {
    expect_error(sprinkle_bg(x, bg = c("red", "blue")))
  }
)

# Functional Requirement 4 ------------------------------------------

test_that(
  "Casts an error if bg is not a valid color format.",
  {
    expect_error(sprinkle_bg(x, bg = "rgb(256, 256, 256)"))
  }
)

test_that(
  "Casts an error if bg is not a valid color format.",
  {
    expect_error(sprinkle_bg(x, bg = "#ZZFFAA0A"))
  }
)

# Functional Requirement 5 ------------------------------------------

test_that(
  "Casts an error if part is not one of body, head, foot, or interfoot",
  {
    expect_error(sprinkle_bg(x, bg = "red", part = "not_a_part"))
  }
)

# Functional Requirement 6 ------------------------------------------

test_that(
  "Casts an error if fixed is not a logical(1)",
  {
    expect_error(sprinkle_bg(x, bg = "red", fixed = "yes"))
  }
)

test_that(
  "Casts an error if fixed is not a logical(1)",
  {
    expect_error(sprinkle_bg(x, bg = "red", fixed = c(TRUE, FALSE)))
  }
)

test_that(
  "Casts an error if recycle is not one of none, rows, or cols",
  {
    expect_error(sprinkle_bg(x, bg = "red", recycle = "not_an_option"))
  }
)