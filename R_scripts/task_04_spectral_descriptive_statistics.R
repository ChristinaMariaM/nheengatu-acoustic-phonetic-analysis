#############################################################
# Task 04 – Spectral-energy measures
# Descriptive statistics and boxplots
#############################################################

library(tidyverse)


# ============================================================
# 1. File paths
# ============================================================

# Replace the placeholders below with the locations of the
# corresponding spectral measurement files on your computer.

oral_antiformant_path <- "PATH_TO_TASK04_ANTIFORMANT_CSV"

nasal_antiformant_path <- "PATH_TO_TASK01_NASAL_ANTIFORMANT_CSV"

oral_band_path <- "PATH_TO_TASK04_NASAL_WINDOW_ENERGY_CSV"

nasal_band_path <- "PATH_TO_TASK01_NASAL_WINDOW_ENERGY_CSV"



# Read files

oral_antiformant <- read_delim(
  oral_antiformant_path,
  delim = ";",
  show_col_types = FALSE
)

nasal_antiformant <- read_delim(
  nasal_antiformant_path,
  delim = ";",
  locale = locale(encoding = "UTF-16BE"),
  show_col_types = FALSE
)

oral_band <- read_delim(
  oral_band_path,
  delim = ";",
  show_col_types = FALSE
)

nasal_band <- read_delim(
  nasal_band_path,
  delim = ";",
  locale = locale(encoding = "UTF-16BE"),
  show_col_types = FALSE
)



# Add group labels

oral_antiformant$group <- "Task 04 /Vnd/"
nasal_antiformant$group <- "Task 01 phonologically nasal"

oral_band$group <- "Task 04 /Vnd/"
nasal_band$group <- "Task 01 phonologically nasal"


# Combine files

antiformant <- bind_rows(
  oral_antiformant,
  nasal_antiformant
)

band_energy <- bind_rows(
  oral_band,
  nasal_band
)


# Ensure measurement columns are numeric

antiformant <- antiformant %>%
  mutate(
    minFreq_Hz = as.numeric(minFreq_Hz),
    minEnergy_dB = as.numeric(minEnergy_dB)
  )

band_energy <- band_energy %>%
  mutate(
    relativeBandEnergy = as.numeric(relativeBandEnergy),
    relativeBandEnergy_dB = as.numeric(relativeBandEnergy_dB)
  )


# Descriptive statistics

# Local spectral-minimum frequency
minFreq_summary <- antiformant %>%
  group_by(group) %>%
  summarise(
    n = sum(!is.na(minFreq_Hz)),
    mean = mean(minFreq_Hz, na.rm = TRUE),
    median = median(minFreq_Hz, na.rm = TRUE),
    sd = sd(minFreq_Hz, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    measure = "Local spectral-minimum frequency (Hz)"
  ) %>%
  select(
    group,
    measure,
    n,
    mean,
    median,
    sd
  )


# Local spectral-minimum energy
minEnergy_summary <- antiformant %>%
  group_by(group) %>%
  summarise(
    n = sum(!is.na(minEnergy_dB)),
    mean = mean(minEnergy_dB, na.rm = TRUE),
    median = median(minEnergy_dB, na.rm = TRUE),
    sd = sd(minEnergy_dB, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    measure = "Local spectral-minimum energy (dB)"
  ) %>%
  select(
    group,
    measure,
    n,
    mean,
    median,
    sd
  )


# Relative spectral band energy – raw ratio
relativeEnergy_raw_summary <- band_energy %>%
  group_by(group) %>%
  summarise(
    n = sum(!is.na(relativeBandEnergy)),
    mean = mean(relativeBandEnergy, na.rm = TRUE),
    median = median(relativeBandEnergy, na.rm = TRUE),
    sd = sd(relativeBandEnergy, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    measure = "Relative spectral band energy"
  ) %>%
  select(
    group,
    measure,
    n,
    mean,
    median,
    sd
  )


# Relative nasal-window energy – final dB measure
relativeEnergy_dB_summary <- band_energy %>%
  group_by(group) %>%
  summarise(
    n = sum(!is.na(relativeBandEnergy_dB)),
    mean = mean(relativeBandEnergy_dB, na.rm = TRUE),
    median = median(relativeBandEnergy_dB, na.rm = TRUE),
    sd = sd(relativeBandEnergy_dB, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    measure = "Relative nasal-window energy (dB)"
  ) %>%
  select(
    group,
    measure,
    n,
    mean,
    median,
    sd
  )


# Combine descriptive statistics

descriptive_summary <- bind_rows(
  minFreq_summary,
  minEnergy_summary,
  relativeEnergy_raw_summary,
  relativeEnergy_dB_summary
)


# Display results
print(descriptive_summary)


# Save descriptive statistics

write_csv(
  descriptive_summary,
  "task04_spectral_descriptive_statistics.csv"
)

getwd()

# Optional: save each measure separately
write_csv(
  minFreq_summary,
  "task04_local_spectral_minimum_frequency_summary.csv"
)

write_csv(
  minEnergy_summary,
  "task04_local_spectral_minimum_energy_summary.csv"
)

write_csv(
  relativeEnergy_raw_summary,
  "task04_relative_band_energy_raw_summary.csv"
)

write_csv(
  relativeEnergy_dB_summary,
  "task04_relative_nasal_window_energy_summary.csv"
)


# Boxplots

# Local spectral-minimum frequency
png(
  "boxplot_local_spectral_minimum_frequency.png",
  width = 1800,
  height = 1200,
  res = 300
)

boxplot(
  minFreq_Hz ~ group,
  data = antiformant,
  ylab = "Minimum frequency (Hz)",
  xlab = "",
  main = "Local spectral-minimum frequency"
)

dev.off()


# Local spectral-minimum energy
png(
  "boxplot_local_spectral_minimum_energy_dB.png",
  width = 1800,
  height = 1200,
  res = 300
)

boxplot(
  minEnergy_dB ~ group,
  data = antiformant,
  ylab = "Minimum energy (dB)",
  xlab = "",
  main = "Local spectral-minimum energy"
)

dev.off()


# Relative spectral band energy – raw ratio
png(
  "boxplot_relative_band_energy.png",
  width = 1800,
  height = 1200,
  res = 300
)

boxplot(
  relativeBandEnergy ~ group,
  data = band_energy,
  ylab = "Relative band energy",
  xlab = "",
  main = "Relative spectral band energy"
)

dev.off()


# Relative nasal-window energy – dB
png(
  "boxplot_relative_nasal_window_energy_dB.png",
  width = 1800,
  height = 1200,
  res = 300
)

boxplot(
  relativeBandEnergy_dB ~ group,
  data = band_energy,
  ylab = "Relative nasal-window energy (dB)",
  xlab = "",
  main = "Relative nasal-window energy"
)

dev.off()
