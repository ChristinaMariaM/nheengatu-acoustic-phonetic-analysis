###############################################################
# Task 03 — Glottal stop analysis
###############################################################

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lme4)


# INPUT FILE PATH
# Replace the placeholder with the location of the
# Task 3 glottal-stop annotation spreadsheet.

file_name <- "PATH_TO_TASK03_GLOTTAL_STOP_COUNTS.xlsx"

# Output directory
output_dir <- dirname(file_name)


# Read Excel file

raw <- read_excel(file_name, col_names = FALSE)


# Detect lexical items

words <- raw[2, 4:ncol(raw)] %>%
  unlist() %>%
  as.character()

words <- words[!is.na(words)]


# Create working table

dat <- raw[4:nrow(raw), 1:(3 + length(words))]

colnames(dat) <- c("ID", "Speaker", "Age", words)


# Remove rows that are not real participant data

dat <- dat %>%
  mutate(
    ID = as.character(ID),
    Speaker = as.character(Speaker),
    Age = as.character(Age)
  ) %>%
  filter(
    !is.na(Speaker),
    grepl("^l[12]_spk", Speaker, ignore.case = TRUE)
  )


# Convert to long format
# Empty cells are ignored

long <- dat %>%
  pivot_longer(
    cols = all_of(words),
    names_to = "Word",
    values_to = "Response"
  ) %>%
  filter(
    !is.na(Response),
    Response != ""
  ) %>%
  mutate(
    Response = as.character(Response),
    Group = ifelse(grepl("^l1", Speaker, ignore.case = TRUE), "L1", "L2"),
    Glottal = ifelse(Response == "ʔ", 1, 0)
  )


# Check data

cat("\nNumber of real speakers:\n")
print(n_distinct(long$Speaker))

cat("\nNumber of valid observations:\n")
print(nrow(long))

cat("\nMissing values:\n")
print(colSums(is.na(long)))

cat("\nNumber of glottal stops:\n")
print(sum(long$Glottal))


# Summary by word

summary_word <- long %>%
  group_by(Word) %>%
  summarise(
    N = n(),
    GlottalStops = sum(Glottal),
    Percentage = round(100 * mean(Glottal), 1),
    .groups = "drop"
  )

write.csv(
  summary_word,
  file.path(output_dir, "task03_glottal_stop_summary_by_word.csv"),
  row.names = FALSE
)


# Summary by L1/L2

summary_group <- long %>%
  group_by(Group) %>%
  summarise(
    N = n(),
    GlottalStops = sum(Glottal),
    Percentage = round(100 * mean(Glottal), 1),
    .groups = "drop"
  )

write.csv(
  summary_group,
  file.path(output_dir, "task03_glottal_stop_summary_by_group.csv"),
  row.names = FALSE
)


# Summary by age

summary_age <- long %>%
  group_by(Age) %>%
  summarise(
    N = n(),
    GlottalStops = sum(Glottal),
    Percentage = round(100 * mean(Glottal), 1),
    .groups = "drop"
  )

write.csv(
  summary_age,
  file.path(output_dir, "task03_glottal_stop_summary_by_age.csv"),
  row.names = FALSE
)


# Complete summary text file

capture.output(
  cat("SUMMARY BY WORD\n\n"),
  print(summary_word),
  cat("\n\nSUMMARY BY L1/L2\n\n"),
  print(summary_group),
  cat("\n\nSUMMARY BY AGE\n\n"),
  print(summary_age),
  file = file.path(output_dir, "task03_glottal_stop_complete_summary.txt")
)


# Bar chart

barplot_glottal <- ggplot(
  summary_word,
  aes(x = reorder(Word, Percentage), y = Percentage)
) +
  geom_col(fill = "steelblue") +
  geom_text(
    aes(label = paste0(Percentage, "%")),
    vjust = -0.4,
    size = 4
  ) +
  labs(
    title = "Glottal stop occurrence by lexical item",
    x = "Lexical item",
    y = "Productions with a glottal stop (%)"
  ) +
  ylim(0, 100) +
  theme_classic()

print(barplot_glottal)

ggsave(
  filename = file.path(output_dir, "task03_glottal_stop_barplot.png"),
  plot = barplot_glottal,
  width = 8,
  height = 5,
  dpi = 300
)


# Fisher's Exact Test or Chi-square test

tab <- table(long$Word, long$Glottal)

chi <- suppressWarnings(chisq.test(tab))

if (any(chi$expected < 5)) {
  
  test_result <- fisher.test(tab)
  test_name <- "Fisher's Exact Test"
  
} else {
  
  test_result <- chi
  test_name <- "Chi-square Test"
}

capture.output(
  cat(test_name, "\n\n"),
  cat("Contingency table:\n\n"),
  print(tab),
  cat("\n\nTest result:\n\n"),
  print(test_result),
  file = file.path(output_dir, "task03_glottal_stop_test_results.txt")
)

# Logistic mixed-effects model with L1 status as predictor

names(long)

library(lme4)
library(dplyr)
library(stringr)

# Create l1_status from the Speaker ID
long <- long %>%
  mutate(
    l1_status = factor(
      str_extract(Speaker, "^l[12]"),
      levels = c("l1", "l2")
    ),
    Speaker = factor(Speaker),
    Glottal = as.integer(Glottal)
  )


# Check extraction

table(long$l1_status, useNA = "ifany")


# Fit the model

model_glottal_L1 <- glmer(
  Glottal ~ l1_status + (1 | Speaker),
  data = long,
  family = binomial
)


# Print model summary

summary(model_glottal_L1)


# Save model summary

capture.output(
  summary(model_glottal_L1),
  file = file.path(
    output_dir,
    "task03_glottal_L1_status_model_summary.txt"
  )
)


# Save fixed effects

fixed_effects <- as.data.frame(summary(model_glottal_L1)$coefficients)
fixed_effects$Term <- rownames(fixed_effects)
rownames(fixed_effects) <- NULL

fixed_effects <- fixed_effects[, c(
  "Term",
  "Estimate",
  "Std. Error",
  "z value",
  "Pr(>|z|)"
)]

names(fixed_effects) <- c(
  "Term",
  "Estimate_Logit",
  "Std_Error",
  "z_value",
  "p_value"
)

fixed_effects$Odds_Ratio <- exp(fixed_effects$Estimate_Logit)

write.csv(
  fixed_effects,
  file.path(
    output_dir,
    "task03_glottal_L1_status_fixed_effects.csv"
  ),
  row.names = FALSE
)


# Save random effects

random_effects <- as.data.frame(VarCorr(model_glottal_L1))

write.csv(
  random_effects,
  file.path(
    output_dir,
    "task03_glottal_L1_status_random_effects.csv"
  ),
  row.names = FALSE
)


# Save model diagnostics

model_info <- data.frame(
  Observations = nobs(model_glottal_L1),
  Singular = isSingular(model_glottal_L1, tol = 1e-4),
  AIC = AIC(model_glottal_L1),
  BIC = BIC(model_glottal_L1),
  LogLik = as.numeric(logLik(model_glottal_L1))
)

write.csv(
  model_info,
  file.path(
    output_dir,
    "task03_glottal_L1_status_model_info.csv"
  ),
  row.names = FALSE
)


# Print results

cat("\nModel summary:\n")
print(summary(model_glottal_L1))

cat("\nFixed effects:\n")
print(fixed_effects)

cat("\nRandom effects:\n")
print(random_effects)

cat("\nModel information:\n")
print(model_info)

