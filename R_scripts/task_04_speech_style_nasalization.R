###############################################################
# Task04a vs Task04b - Effect of speech style on nasalization
# Comparison with boxplots + paired Wilcoxon tests
###############################################################

library(tidyverse)


# Select input files
# Choose the Task 04 antiformant measurement CSV first,
# followed by the Task 04 relative nasal-window energy CSV.
# Both files must contain Task 04a and Task 04b observations.

anti_file <- file.choose()
band_file <- file.choose()


# Read files

anti <- read_delim(
  anti_file,
  delim = ";",
  show_col_types = FALSE
)

band <- read_delim(
  band_file,
  delim = ";",
  show_col_types = FALSE
)


# Further checks
names(anti)
names(band)

dim(anti)
dim(band)



# Prepare antiformant data

anti <- anti %>%
  mutate(
    task = str_extract(file, "task04[ab]"),
    
    speech_type = case_when(
      task == "task04a" ~ "read_speech",
      task == "task04b" ~ "spontaneous_speech"
    ),
    
    speaker = str_extract(file, "spk[0-9]+"),
    
    vowel = label,
    
    minFreq_Hz = as.numeric(minFreq_Hz),
    minEnergy_dB = as.numeric(minEnergy_dB)
  ) %>%
  filter(!is.na(task))



# Prepare band-energy data

band <- band %>%
  mutate(
    task = str_extract(file, "task04[ab]"),
    
    speech_type = case_when(
      task == "task04a" ~ "read_speech",
      task == "task04b" ~ "spontaneous_speech"
    ),
    
    speaker = str_extract(file, "spk[0-9]+"),
    
    vowel = label,
    
    relativeBandEnergy = as.numeric(relativeBandEnergy),
    relativeBandEnergy_dB = as.numeric(relativeBandEnergy_dB)
  ) %>%
  filter(!is.na(task))



# Descriptive statistics

anti_summary <- anti %>%
  group_by(speech_type) %>%
  summarise(
    n = n(),
    
    mean_minEnergy_dB =
      mean(minEnergy_dB, na.rm = TRUE),
    
    median_minEnergy_dB =
      median(minEnergy_dB, na.rm = TRUE),
    
    sd_minEnergy_dB =
      sd(minEnergy_dB, na.rm = TRUE),
    
    mean_minFreq_Hz =
      mean(minFreq_Hz, na.rm = TRUE),
    
    median_minFreq_Hz =
      median(minFreq_Hz, na.rm = TRUE),
    
    sd_minFreq_Hz =
      sd(minFreq_Hz, na.rm = TRUE),
    
    .groups = "drop"
  )


band_summary <- band %>%
  group_by(speech_type) %>%
  summarise(
    n = n(),
    
    mean_relativeBandEnergy_dB =
      mean(relativeBandEnergy_dB, na.rm = TRUE),
    
    median_relativeBandEnergy_dB =
      median(relativeBandEnergy_dB, na.rm = TRUE),
    
    sd_relativeBandEnergy_dB =
      sd(relativeBandEnergy_dB, na.rm = TRUE),
    
    .groups = "drop"
  )


print(anti_summary)
print(band_summary)



# Boxplots – one point per token

# Relative nasal-window energy
ggplot(
  band,
  aes(
    x = speech_type,
    y = relativeBandEnergy_dB
  )
) +
  geom_boxplot(
    outlier.alpha = 0.4
  ) +
  geom_jitter(
    width = 0.15,
    alpha = 0.4
  ) +
  labs(
    title = "Relative nasal-window energy: task04a vs task04b",
    x = "Speech style",
    y = "Relative nasal-window energy (dB)"
  ) +
  theme_bw()


# Local spectral-minimum energy
ggplot(
  anti,
  aes(
    x = speech_type,
    y = minEnergy_dB
  )
) +
  geom_boxplot(
    outlier.alpha = 0.4
  ) +
  geom_jitter(
    width = 0.15,
    alpha = 0.4
  ) +
  labs(
    title = "Local spectral-minimum energy: task04a vs task04b",
    x = "Speech style",
    y = "Minimum energy (dB)"
  ) +
  theme_bw()


# Local spectral-minimum frequency
ggplot(
  anti,
  aes(
    x = speech_type,
    y = minFreq_Hz
  )
) +
  geom_boxplot(
    outlier.alpha = 0.4
  ) +
  geom_jitter(
    width = 0.15,
    alpha = 0.4
  ) +
  labs(
    title = "Local spectral-minimum frequency: task04a vs task04b",
    x = "Speech style",
    y = "Minimum-energy frequency (Hz)"
  ) +
  theme_bw()


# Paired Wilcoxon tests

paired_wilcox <- function(data, value_col) {
  
  data_avg <- data %>%
    group_by(
      speaker,
      speech_type
    ) %>%
    summarise(
      value =
        mean(
          .data[[value_col]],
          na.rm = TRUE
        ),
      
      .groups = "drop"
    ) %>%
    pivot_wider(
      names_from = speech_type,
      values_from = value
    ) %>%
    drop_na(
      read_speech,
      spontaneous_speech
    )
  
  print(data_avg)
  
  test <- wilcox.test(
    data_avg$read_speech,
    data_avg$spontaneous_speech,
    paired = TRUE,
    exact = FALSE
  )
  
  return(test)
}


# Relative nasal-window energy

band_test <- paired_wilcox(
  band,
  "relativeBandEnergy_dB"
)

print(band_test)


# Local spectral-minimum energy

anti_energy_test <- paired_wilcox(
  anti,
  "minEnergy_dB"
)

print(anti_energy_test)


# Local spectral-minimum frequency

anti_freq_test <- paired_wilcox(
  anti,
  "minFreq_Hz"
)

print(anti_freq_test)


# Save summaries

write_csv(
  anti_summary,
  "task04_antiformant_summary.csv"
)

write_csv(
  band_summary,
  "task04_band_energy_summary.csv"
)



# Create compact Wilcoxon summary table

wilcox_summary <- data.frame(
  Measurement = c(
    "Relative nasal-window energy",
    "Local spectral-minimum energy",
    "Local spectral-minimum frequency"
  ),
  
  W = c(
    unname(
      band_test$statistic
    ),
    
    unname(
      anti_energy_test$statistic
    ),
    
    unname(
      anti_freq_test$statistic
    )
  ),
  
  p_value = c(
    band_test$p.value,
    anti_energy_test$p.value,
    anti_freq_test$p.value
  )
)


print(
  wilcox_summary
)


write_csv(
  wilcox_summary,
  "task04_wilcoxon_summary.csv"
)

getwd()


# Speaker-level averages for paired plots

band_paired <- band %>%
  group_by(
    speaker,
    speech_type
  ) %>%
  summarise(
    value =
      mean(
        relativeBandEnergy_dB,
        na.rm = TRUE
      ),
    
    .groups = "drop"
  )


anti_energy_paired <- anti %>%
  group_by(
    speaker,
    speech_type
  ) %>%
  summarise(
    value =
      mean(
        minEnergy_dB,
        na.rm = TRUE
      ),
    
    .groups = "drop"
  )


anti_freq_paired <- anti %>%
  group_by(
    speaker,
    speech_type
  ) %>%
  summarise(
    value =
      mean(
        minFreq_Hz,
        na.rm = TRUE
      ),
    
    .groups = "drop"
  )



# Paired plots – one point per speaker per speech style


# Relative nasal-window energy
ggplot(
  band_paired,
  aes(
    x = speech_type,
    y = value,
    group = speaker
  )
) +
  geom_line(
    alpha = 0.5
  ) +
  geom_point(
    size = 2
  ) +
  labs(
    title = "Relative nasal-window energy: task04a vs task04b",
    x = "Speech style",
    y = "Relative nasal-window energy (dB)"
  ) +
  theme_bw()


# Local spectral-minimum energy
ggplot(
  anti_energy_paired,
  aes(
    x = speech_type,
    y = value,
    group = speaker
  )
) +
  geom_line(
    alpha = 0.5
  ) +
  geom_point(
    size = 2
  ) +
  labs(
    title = "Local spectral-minimum energy: task04a vs task04b",
    x = "Speech style",
    y = "Minimum energy (dB)"
  ) +
  theme_bw()


# Local spectral-minimum frequency
ggplot(
  anti_freq_paired,
  aes(
    x = speech_type,
    y = value,
    group = speaker
  )
) +
  geom_line(
    alpha = 0.5
  ) +
  geom_point(
    size = 2
  ) +
  labs(
    title = "Local spectral-minimum frequency: task04a vs task04b",
    x = "Speech style",
    y = "Minimum-energy frequency (Hz)"
  ) +
  theme_bw()

anti %>%
  count(speaker, speech_type) %>%
  pivot_wider(
    names_from = speech_type,
    values_from = n,
    values_fill = 0
  )

band %>%
  count(speaker, speech_type) %>%
  pivot_wider(
    names_from = speech_type,
    values_from = n,
    values_fill = 0
  )