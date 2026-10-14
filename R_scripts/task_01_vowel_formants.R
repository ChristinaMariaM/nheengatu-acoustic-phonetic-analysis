###############################################################
# Task 01 - Median F1/F2 per file and plots
###############################################################

# INPUT FILE PATHS
# Replace the placeholders below with the locations of the
# corresponding measurement tables on your computer.

main_file <- "PATH_TO_MAIN_FORMANT_TABLE"
u_nasal_file <- "PATH_TO_CORRECTED_U_NASAL_TABLE"

library(tidyverse)

data <- read.delim(
  main_file,
  fileEncoding = "UTF-16"
)

vowel_space <- data %>%
  group_by(file, spkr, sex, task, item, vowel) %>%
  summarise(
    F1 = median(f1, na.rm = TRUE),
    F2 = median(f2, na.rm = TRUE),
    duration = first(duration),
    .groups = "drop"
  )

# filled ellipsis 
ggplot(vowel_space, aes(x = F2, y = F1, color = vowel, fill = vowel)) +
  geom_point(size = 1.5, alpha = 0.7) +
  
  stat_ellipse(
    geom = "polygon",
    alpha = 0.15,
    level = 0.95,
    linewidth = 0.8
  ) +
  
  scale_x_reverse() +
  scale_y_reverse() +
  
  labs(
    title = "Vowel space by vowel",
    x = "F2 (Hz)",
    y = "F1 (Hz)",
    color = "Vowel",
    fill = "Vowel"
  ) +
  
  theme_bw()

# filled ellipsis reduced y-axis
ggplot(vowel_space, aes(x = F2, y = F1, color = vowel, fill = vowel)) +
  geom_point(size = 1.5, alpha = 0.7) +
  
  stat_ellipse(
    geom = "polygon",
    alpha = 0.15,
    level = 0.95,
    linewidth = 0.8
  ) +
  
  scale_x_reverse() +
  
  scale_y_reverse(
    limits = c(1200, 100),
    breaks = seq(1200, 100, -100),
    minor_breaks = seq(1200, 100, -50)
  ) +
  
  labs(
    title = "Vowel space by vowel",
    x = "F2 (Hz)",
    y = "F1 (Hz)",
    color = "Vowel",
    fill = "Vowel"
  ) +
  
  theme_bw()

# Only nasalized vowels for comparison in task 04:

library(dplyr)

# Read data
data <- read.delim(
  main_file,
  fileEncoding = "UTF-16"
)

# Keep only nasalized vowels
data_nasal <- data %>%
  filter(vowel %in% c("ã", "ẽ", "ĩ", "õ", "ũ"))

# Calculate median formants for vowel space
vowel_space <- data_nasal %>%
  group_by(file, spkr, sex, task, item, vowel) %>%
  summarise(
    F1 = median(f1, na.rm = TRUE),
    F2 = median(f2, na.rm = TRUE),
    duration = first(duration),
    .groups = "drop"
  )

# filled ellipsis reduced y-axis
ggplot(vowel_space, aes(x = F2, y = F1, color = vowel, fill = vowel)) +
  geom_point(size = 1.5, alpha = 0.7) +
  
  stat_ellipse(
    geom = "polygon",
    alpha = 0.15,
    level = 0.95,
    linewidth = 0.8
  ) +
  
  scale_x_reverse() +
  
  scale_y_reverse(
    limits = c(1200, 100),
    breaks = seq(1200, 100, -100),
    minor_breaks = seq(1200, 100, -50)
  ) +
  
  labs(
    title = "Vowel space by nasalized vowels from task 01",
    x = "F2 (Hz)",
    y = "F1 (Hz)",
    color = "Vowel",
    fill = "Vowel"
  ) +
  
  theme_bw()


# Verify what happened to the vowel /ũ/ that has a too widely distributed f2:

data <- read.delim(
  main_file,
  fileEncoding = "UTF-16"
)

vowel_space <- data %>%
  filter(vowel == "ũ") %>%
  group_by(file, spkr, sex, task, item, vowel) %>%
  summarise(
    F1 = median(f1, na.rm = TRUE),
    F2 = median(f2, na.rm = TRUE),
    duration = first(duration),
    .groups = "drop"
  )

ggplot(vowel_space, aes(x = F2, y = F1, color = vowel, fill = vowel)) +
  geom_point(size = 1.5, alpha = 0.7) +
  
  stat_ellipse(
    geom = "polygon",
    alpha = 0.15,
    level = 0.95,
    linewidth = 0.8
  ) +
  
  scale_x_reverse(
    limits = c(4000, -500),
    breaks = c(3000, 2000, 1000, 0),
    expand = expansion(mult = c(0.01, 0.01))
  ) +
  
  scale_y_reverse(
    limits = c(1200, 100),
    breaks = seq(1200, 100, -100),
    minor_breaks = seq(1200, 100, -50)
  ) +
  
  labs(
    title = "Vowel space of ũ",
    x = "F2 (Hz)",
    y = "F1 (Hz)",
    color = "Vowel",
    fill = "Vowel"
  ) +
  
  theme_bw()


### Updated plots with u nasal fixed:
library(dplyr)
library(ggplot2)

# File containing a, e, i, u, ã, ẽ and ĩ
data_main <- read.delim(
  main_file,
  fileEncoding = "UTF-16"
)

# File containing ũ
data_u_nasal <- read.delim(
  u_nasal_file,
  fileEncoding = "UTF-16"
)

# Remove ũ tokens from the first file
data_main <- data_main %>%
  filter(vowel != "ũ")

# All tokens in the second file represent ũ
data_u_nasal <- data_u_nasal %>%
  mutate(vowel = "ũ")

# Combine the files and reduce each token to one F1/F2 pair
vowel_space <- bind_rows(
  data_main,
  data_u_nasal
) %>%
  mutate(
    f1 = as.numeric(f1),
    f2 = as.numeric(f2)
  ) %>%
  filter(
    !is.na(f1),
    !is.na(f2),
    !is.na(vowel)
  ) %>%
  group_by(file, spkr, vowel, lg) %>%
  summarise(
    F1 = median(f1, na.rm = TRUE),
    F2 = median(f2, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    vowel = factor(
      vowel,
      levels = c("a", "ã", "e", "ẽ", "i", "ĩ", "u", "ũ")
    )
  )

ggplot(
  vowel_space,
  aes(
    x = F2,
    y = F1,
    color = vowel,
    fill = vowel
  )
) +
  geom_point(
    size = 1.5,
    alpha = 0.7
  ) +
  stat_ellipse(
    geom = "polygon",
    alpha = 0.15,
    level = 0.95,
    linewidth = 0.8,
    na.rm = TRUE
  ) +
  scale_x_reverse(
    limits = c(3500, 0),
    breaks = c(3000, 2000, 1000, 0),
    expand = expansion(mult = c(0.01, 0.01))
  ) +
  scale_y_reverse(
    limits = c(1200, 100),
    breaks = seq(1200, 100, -100),
    minor_breaks = seq(1200, 100, -50)
  ) +
  labs(
    title = "Nheengatu vowel space",
    subtitle = "L1 and L2 speakers combined; token medians",
    x = "F2 (Hz)",
    y = "F1 (Hz)",
    color = "Vowel",
    fill = "Vowel"
  ) +
  theme_bw()

#ggplot(
# filter(vowel_space, vowel == "ẽ"),
#aes(F2, F1)
#) +
# geom_point(size = 3) +
#  stat_ellipse(level = 0.95)



### Updated plots with ũ fixed and L1/L2 speakers separated

library(dplyr)
library(ggplot2)

# File containing a, e, i, u, ã, ẽ and ĩ
data_main <- read.delim(
  main_file,
  fileEncoding = "UTF-16"
)

# File containing ũ
data_u_nasal <- read.delim(
  u_nasal_file,
  fileEncoding = "UTF-16"
)

# Remove original ũ tokens from the first file
data_main <- data_main %>%
  filter(vowel != "ũ")

# All tokens in the second file represent corrected ũ
data_u_nasal <- data_u_nasal %>%
  mutate(vowel = "ũ")

# Combine the files and reduce each token to one F1/F2 pair
vowel_space <- bind_rows(
  data_main,
  data_u_nasal
) %>%
  mutate(
    f1 = as.numeric(f1),
    f2 = as.numeric(f2),
    lg = factor(lg, levels = c("l1", "l2"), labels = c("L1", "L2"))
  ) %>%
  filter(
    !is.na(f1),
    !is.na(f2),
    !is.na(vowel),
    !is.na(lg)
  ) %>%
  group_by(
    file,
    spkr,
    vowel,
    lg
  ) %>%
  summarise(
    F1 = median(f1, na.rm = TRUE),
    F2 = median(f2, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    vowel = factor(
      vowel,
      levels = c("a", "ã", "e", "ẽ", "i", "ĩ", "u", "ũ")
    )
  )

# Check the number of tokens per vowel and speaker group
count(
  vowel_space,
  lg,
  vowel
)

# Plot L1 and L2 speakers in separate panels
ggplot(
  vowel_space,
  aes(
    x = F2,
    y = F1,
    color = vowel,
    fill = vowel
  )
) +
  geom_point(
    size = 1.5,
    alpha = 0.7
  ) +
  stat_ellipse(
    geom = "polygon",
    alpha = 0.15,
    level = 0.68,
    linewidth = 0.8,
    na.rm = TRUE
  ) +
  facet_wrap(
    ~lg,
    nrow = 1
  ) +
  scale_x_reverse(
    limits = c(3500, 0),
    breaks = c(3000, 2000, 1000, 0),
    expand = expansion(mult = c(0.01, 0.01))
  ) +
  scale_y_reverse(
    limits = c(1200, 100),
    breaks = seq(1200, 100, -100),
    minor_breaks = seq(1200, 100, -50)
  ) +
  labs(
    title = "Nheengatu vowel space",
    subtitle = "Token medians by speaker group",
    x = "F2 (Hz)",
    y = "F1 (Hz)",
    color = "Vowel",
    fill = "Vowel"
  ) +
  theme_bw()


### Lobanov-normalized vowel-space plots:
### 1. All speakers combined
### 2. L1 and L2 speakers separated

library(dplyr)
library(ggplot2)

# File containing a, e, i, u, ã, ẽ and ĩ
data_main <- read.delim(
  main_file,
  fileEncoding = "UTF-16"
)

# File containing corrected ũ
data_u_nasal <- read.delim(
  u_nasal_file,
  fileEncoding = "UTF-16"
)

# Remove original ũ tokens from the first file
data_main <- data_main %>%
  filter(vowel != "ũ")

# All tokens in the second file represent corrected ũ
data_u_nasal <- data_u_nasal %>%
  mutate(vowel = "ũ")

# Combine the files and reduce each token to one F1/F2 pair
vowel_space <- bind_rows(
  data_main,
  data_u_nasal
) %>%
  mutate(
    f1 = as.numeric(f1),
    f2 = as.numeric(f2),
    lg = factor(
      lg,
      levels = c("l1", "l2"),
      labels = c("L1", "L2")
    )
  ) %>%
  filter(
    !is.na(f1),
    !is.na(f2),
    !is.na(vowel),
    !is.na(spkr),
    !is.na(lg)
  ) %>%
  group_by(
    file,
    spkr,
    vowel,
    lg
  ) %>%
  summarise(
    F1 = median(f1, na.rm = TRUE),
    F2 = median(f2, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    vowel = factor(
      vowel,
      levels = c("a", "ã", "e", "ẽ", "i", "ĩ", "u", "ũ")
    )
  )

# Lobanov normalization within each individual speaker
vowel_space_norm <- vowel_space %>%
  group_by(spkr) %>%
  mutate(
    F1_z = (
      F1 - mean(F1, na.rm = TRUE)
    ) / sd(F1, na.rm = TRUE),
    
    F2_z = (
      F2 - mean(F2, na.rm = TRUE)
    ) / sd(F2, na.rm = TRUE)
  ) %>%
  ungroup()

# Check whether normalization worked
normalization_check <- vowel_space_norm %>%
  group_by(spkr) %>%
  summarise(
    n_tokens = n(),
    mean_F1_z = mean(F1_z, na.rm = TRUE),
    sd_F1_z = sd(F1_z, na.rm = TRUE),
    mean_F2_z = mean(F2_z, na.rm = TRUE),
    sd_F2_z = sd(F2_z, na.rm = TRUE),
    .groups = "drop"
  )

print(normalization_check)

# Check token counts
count(
  vowel_space_norm,
  lg,
  vowel
)

# Plot 1: all speakers combined

centroids_all <- vowel_space_norm %>%
  group_by(vowel) %>%
  summarise(
    F1_centroid = mean(F1_z, na.rm = TRUE),
    F2_centroid = mean(F2_z, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(
  vowel_space_norm,
  aes(
    x = F2_z,
    y = F1_z,
    colour = vowel
  )
) +
  geom_point(
    size = 1.3,
    alpha = 0.35
  ) +
  
  stat_ellipse(
    type = "norm",
    level = 0.68,
    linewidth = 0.8,
    na.rm = TRUE,
    show.legend = FALSE
  ) +
  
  geom_point(
    data = centroids_all,
    aes(
      x = F2_centroid,
      y = F1_centroid,
      colour = vowel
    ),
    shape = 4,
    size = 4.5,
    stroke = 1.3,
    inherit.aes = FALSE
  ) +
  
  scale_x_reverse() +
  scale_y_reverse() +
  
  labs(
    title = "Normalized Nheengatu vowel space",
    subtitle = "Lobanov-normalized token medians; all speakers combined",
    x = "Normalized F2 (Lobanov)",
    y = "Normalized F1 (Lobanov)",
    colour = "Vowel"
  ) +
  
  theme_bw()

# Plot 2: L1 and L2 speakers separated

ggplot(
  vowel_space_norm,
  aes(
    x = F2_z,
    y = F1_z,
    color = vowel,
    fill = vowel
  )
) +
  geom_point(
    size = 1.5,
    alpha = 0.7
  ) +
  stat_ellipse(
    type = "norm",
    geom = "polygon",
    alpha = 0.15,
    level = 0.68,
    linewidth = 0.8,
    na.rm = TRUE
  ) +
  facet_wrap(
    ~lg,
    nrow = 1
  ) +
  scale_x_reverse() +
  scale_y_reverse() +
  labs(
    title = "Normalized Nheengatu vowel space",
    subtitle = "Lobanov-normalized token medians by speaker group",
    x = "Normalized F2 (Lobanov)",
    y = "Normalized F1 (Lobanov)",
    color = "Vowel",
    fill = "Vowel"
  ) +
  theme_bw()


# Faceted scatter plot for L1/L2

centroids_L1_L2 <- vowel_space_norm %>%
  group_by(
    lg,
    vowel
  ) %>%
  summarise(
    F1_centroid = mean(F1_z, na.rm = TRUE),
    F2_centroid = mean(F2_z, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

# Plot 3: L1 and L2 speakers separated with vowel centroids

ggplot(
  vowel_space_norm,
  aes(
    x = F2_z,
    y = F1_z,
    colour = vowel
  )
) +
  
  # Individual vowel tokens
  geom_point(
    alpha = 0.35,
    size = 1.8
  ) +
  
  # Vowel centroids
  geom_point(
    data = centroids_L1_L2,
    aes(
      x = F2_centroid,
      y = F1_centroid,
      colour = vowel
    ),
    shape = 4,
    size = 5,
    stroke = 1.4,
    inherit.aes = FALSE
  ) +
  
  # Labels at the centroids
  geom_text(
    data = centroids_L1_L2,
    aes(
      x = F2_centroid,
      y = F1_centroid,
      label = vowel,
      colour = vowel
    ),
    nudge_y = -0.12,
    fontface = "bold",
    size = 4,
    show.legend = FALSE,
    inherit.aes = FALSE
  ) +
  
  facet_wrap(
    ~lg
  ) +
  
  scale_x_reverse() +
  scale_y_reverse() +
  
  labs(
    title = "Normalized Nheengatu vowel space",
    subtitle = "Lobanov-normalized token medians by speaker group",
    x = "Normalized F2 (Lobanov)",
    y = "Normalized F1 (Lobanov)",
    colour = "Vowel"
  ) +
  
  theme_classic()

### Descriptive statistics

library(dplyr)

# File containing a, e, i, u, ã, ẽ and ĩ
data_main <- read.delim(
  main_file,
  fileEncoding = "UTF-16"
)

# File containing ũ
data_u_nasal <- read.delim(
  u_nasal_file,
  fileEncoding = "UTF-16"
)

# Remove the old/incorrect ũ tokens from the first file
data_main <- data_main %>%
  filter(vowel != "ũ")

# All tokens in the second file represent corrected ũ
data_u_nasal <- data_u_nasal %>%
  mutate(vowel = "ũ")


# Check that the required columns are present

required_columns <- c("file", "spkr", "vowel", "f1", "f2")

missing_main <- setdiff(required_columns, names(data_main))
missing_u <- setdiff(required_columns, names(data_u_nasal))

if (length(missing_main) > 0) {
  stop(
    paste(
      "Missing columns in data_main:",
      paste(missing_main, collapse = ", ")
    )
  )
}

if (length(missing_u) > 0) {
  stop(
    paste(
      "Missing columns in data_u_nasal:",
      paste(missing_u, collapse = ", ")
    )
  )
}


# Create one observation per vowel token

token_data_main <- data_main %>%
  group_by(file, spkr, vowel) %>%
  summarise(
    f1 = median(f1, na.rm = TRUE),
    f2 = median(f2, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(
    is.finite(f1),
    is.finite(f2)
  )

token_data_u_nasal <- data_u_nasal %>%
  group_by(file, spkr, vowel) %>%
  summarise(
    f1 = median(f1, na.rm = TRUE),
    f2 = median(f2, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(
    is.finite(f1),
    is.finite(f2)
  )


# Define the order of the vowels

main_vowel_order <- c(
  "a", "ã",
  "e", "ẽ",
  "i", "ĩ",
  "u"
)

token_data_main <- token_data_main %>%
  mutate(
    vowel = factor(
      vowel,
      levels = main_vowel_order
    )
  )

token_data_u_nasal <- token_data_u_nasal %>%
  mutate(
    vowel = factor(
      vowel,
      levels = "ũ"
    )
  )


# Function for calculating descriptive statistics

calculate_raw_descriptives <- function(data) {
  
  data %>%
    group_by(vowel) %>%
    summarise(
      n = n(),
      
      # f1
      f1_mean_Hz = mean(f1, na.rm = TRUE),
      f1_SD_Hz = sd(f1, na.rm = TRUE),
      f1_median_Hz = median(f1, na.rm = TRUE),
      f1_IQR_Hz = IQR(f1, na.rm = TRUE),
      f1_min_Hz = min(f1, na.rm = TRUE),
      f1_max_Hz = max(f1, na.rm = TRUE),
      
      # F2
      f2_mean_Hz = mean(f2, na.rm = TRUE),
      f2_SD_Hz = sd(f2, na.rm = TRUE),
      f2_median_Hz = median(f2, na.rm = TRUE),
      f2_IQR_Hz = IQR(f2, na.rm = TRUE),
      f2_min_Hz = min(f2, na.rm = TRUE),
      f2_max_Hz = max(f2, na.rm = TRUE),
      
      .groups = "drop"
    ) %>%
    mutate(
      f1_mean_Hz = round(f1_mean_Hz, 1),
      f1_SD_Hz = round(f1_SD_Hz, 1),
      f1_median_Hz = round(f1_median_Hz, 1),
      f1_IQR_Hz = round(f1_IQR_Hz, 1),
      f1_min_Hz = round(f1_min_Hz, 1),
      f1_max_Hz = round(f1_max_Hz, 1),
      
      f2_mean_Hz = round(f2_mean_Hz, 1),
      f2_SD_Hz = round(f2_SD_Hz, 1),
      f2_median_Hz = round(f2_median_Hz, 1),
      f2_IQR_Hz = round(f2_IQR_Hz, 1),
      f2_min_Hz = round(f2_min_Hz, 1),
      f2_max_Hz = round(f2_max_Hz, 1)
    )
}


# Create the two descriptive tables

# Table 1: a, e, i, u, ã, ẽ and ĩ
table_1_raw_main_vowels <- calculate_raw_descriptives(
  token_data_main
)

# Table 2: corrected ũ
table_2_raw_u_nasal <- calculate_raw_descriptives(
  token_data_u_nasal
)


# Display the tables in R

print(table_1_raw_main_vowels, n = Inf)
print(table_2_raw_u_nasal, n = Inf)


# Optional: open the tables in the RStudio data viewer
View(table_1_raw_main_vowels)
View(table_2_raw_u_nasal)


# Export the tables as CSV files

getwd()

write.csv2(
  table_1_raw_main_vowels,
  file = "Table_1_raw_descriptive_statistics_main_vowels.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

write.csv2(
  table_2_raw_u_nasal,
  file = "Table_2_raw_descriptive_statistics_u_nasal.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)


# Further checks

# Number of vowel tokens in Table 1
token_data_main %>%
  count(vowel)

# Number of corrected ũ tokens in Table 2
token_data_u_nasal %>%
  count(vowel)

data_main %>%
  filter(vowel == "ĩ") %>%
  distinct(file, spkr, vowel) %>%
  arrange(spkr, file)

data_main %>%
  filter(vowel == "ĩ") %>%
  distinct(file, spkr, vowel) %>%
  count(spkr)
