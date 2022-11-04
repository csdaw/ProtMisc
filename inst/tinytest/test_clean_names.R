# Test all scenarios for old_make_clean_names()

expect_equal(
  ProtMisc:::old_make_clean_names("sp ace"),
  "sp_ace",
)

expect_equal(
  ProtMisc:::old_make_clean_names(c("repeated", "repeated", "REPEATED")),
  paste0("repeated", c("", "_2", "_3"))
)

expect_equal(
  ProtMisc:::old_make_clean_names("a**^@"),
  "a"
)
expect_equal(
  ProtMisc:::old_make_clean_names("%"),
  "percent"
)

expect_equal(
  ProtMisc:::old_make_clean_names("*"),
  "x"
)

expect_equal(
  ProtMisc:::old_make_clean_names("!"),
  "x"
)

expect_equal(
  ProtMisc:::old_make_clean_names(c("*", "!")),
  c("x", "x_2")
)

expect_equal(
  ProtMisc:::old_make_clean_names("d(!)9"),
  "d_9"
)

expect_equal(
  ProtMisc:::old_make_clean_names("can\"'t"),
  "cant"
)

expect_equal(
  ProtMisc:::old_make_clean_names("hi_`there`"),
  "hi_there"
)

expect_equal(
  ProtMisc:::old_make_clean_names("  leading spaces"),
  "leading_spaces"
)

expect_equal(
  ProtMisc:::old_make_clean_names("€"),
  "x"
)
