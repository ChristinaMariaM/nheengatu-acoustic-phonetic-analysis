###############################################################
# Task 04 - Descriptive statistics for /n/ duration
###############################################################


#install.packages("readxl")
#install.packages("writexl")

library(readxl)
library(dplyr)
library(writexl)

# Import the Excel file

# Replace the placeholder with the location of the
# Task 4 nasal consonant duration spreadsheet.

file_path <- "PATH_TO_N_DURATIONS.xlsx"

n_data <- read_excel(file_path)

# Inspect the imported data
str(n_data)
head(n_data)


# Check the relevant variables

table(n_data$item, useNA = "ifany")
summary(n_data$n_duration_ms)


# Descriptive statistics by sequence

duration_by_item <- n_data %>%
  filter(
    item %in% c("and", "end", "ind", "und"),
    !is.na(n_duration_ms)
  ) %>%
  group_by(item) %>%
  summarise(
    n = n(),
    mean_ms = mean(n_duration_ms),
    median_ms = median(n_duration_ms),
    sd_ms = sd(n_duration_ms),
    min_ms = min(n_duration_ms),
    max_ms = max(n_duration_ms),
    .groups = "drop"
  ) %>%
  mutate(
    item = factor(
      item,
      levels = c("and", "end", "ind", "und")
    )
  ) %>%
  arrange(item) %>%
  mutate(
    item = as.character(item)
  )


# Overall descriptive statistics

duration_overall <- n_data %>%
  filter(
    item %in% c("and", "end", "ind", "und"),
    !is.na(n_duration_ms)
  ) %>%
  summarise(
    item = "Overall",
    n = n(),
    mean_ms = mean(n_duration_ms),
    median_ms = median(n_duration_ms),
    sd_ms = sd(n_duration_ms),
    min_ms = min(n_duration_ms),
    max_ms = max(n_duration_ms)
  )


# Combine, round, and rename columns

duration_summary <- bind_rows(
  duration_by_item,
  duration_overall
) %>%
  mutate(
    across(
      c(mean_ms, median_ms, sd_ms, min_ms, max_ms),
      ~ round(.x, 1)
    )
  ) %>%
  rename(
    Sequence = item,
    Mean_ms = mean_ms,
    Median_ms = median_ms,
    SD_ms = sd_ms,
    Min_ms = min_ms,
    Max_ms = max_ms
  )

print(duration_summary)


# Export the results to Excel

# Replace the placeholder with the desired location
# and filename of the output spreadsheet.

output_path <- "PATH_TO_N_DURATION_SUMMARY.xlsx"

write_xlsx(
  duration_summary,
  output_path
)

cat(
  "\nSummary table saved to:\n",
  output_path,
  "\n"
)
