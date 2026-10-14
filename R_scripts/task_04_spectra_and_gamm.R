############################################################
# Task 04 - spectra and GAMM
############################################################


# File paths

# Replace these placeholders with the corresponding local
# input and output file paths.

task01_file <- "PATH_TO_TASK01_SPECTRA.xlsx"

task04_file <- "PATH_TO_TASK04_SPECTRA.xlsx"

gamm_output_file <- "PATH_TO_GAMM_RESULTS.xlsx"

library(readxl)
library(dplyr)
library(ggplot2)


# Reference speakers used for Task 01 / Task 04 comparison

reference_speakers <- c(1, 2, 6, 8, 13)


# Task 01 - oral vs. nasal spectral comparison

# Read data

task01 <- read_excel(
  task01_file
)

task01 <- task01 %>%
  mutate(
    frequency_hz = as.numeric(frequency_hz),
    amplitude_db_hz = as.numeric(amplitude_db_hz),
    
    # Extract speaker label, e.g. l1_spk01
    speaker = sub(
      "^(l[12]_spk[0-9]+).*",
      "\\1",
      token
    ),
    
    # Extract speaker number, e.g. 1
    speaker_number = as.numeric(
      sub(
        "^l[12]_spk0*",
        "",
        speaker
      )
    )
  ) %>%
  
  # Keep only the five reference speakers
  filter(
    speaker_number %in% reference_speakers
  )


# Check speakers

print(
  task01 %>%
    distinct(
      speaker,
      speaker_number
    )
)


# Center each spectrum

task01 <- task01 %>%
  group_by(token) %>%
  mutate(
    amplitude = amplitude_db_hz -
      mean(
        amplitude_db_hz,
        na.rm = TRUE
      )
  ) %>%
  ungroup()


# Plot all individual Task 01 spectra

p1_task01_individual <- ggplot(
  task01,
  aes(
    x = frequency_hz,
    y = amplitude,
    group = token,
    colour = nasality
  )
) +
  geom_line(
    alpha = 0.60
  ) +
  facet_wrap(
    ~vowel_base
  ) +
  labs(
    title = "Individual oral and nasal spectra of Task 01",
    x = "Frequency (Hz)",
    y = "Centered amplitude (dB)",
    colour = "Nasality"
  ) +
  theme_bw()

print(
  p1_task01_individual
)


# Calculate mean Task 01 spectra

meanSpectra <- task01 %>%
  group_by(
    vowel_base,
    nasality,
    frequency_hz
  ) %>%
  summarise(
    amplitude = mean(
      amplitude,
      na.rm = TRUE
    ),
    .groups = "drop"
  )


# Plot mean Task 01 spectra

p2_task01_mean <- ggplot(
  meanSpectra,
  aes(
    x = frequency_hz,
    y = amplitude,
    colour = nasality
  )
) +
  
  geom_smooth(
    method = "loess",
    span = 0.10,
    se = FALSE,
    linewidth = 1
  ) +
  
  facet_wrap(
    ~vowel_base
  ) +
  
  labs(
    title = "Mean oral and nasal spectra of Task 01",
    x = "Frequency (Hz)",
    y = "Mean centered amplitude (dB)",
    colour = "Nasality"
  ) +
  
  theme_bw()

print(
  p2_task01_mean
)



# Task 01 and Task 04 Spectral Overlay

# Read Task 01

task01 <- read_excel(
  task01_file
)

task01 <- task01 %>%
  mutate(
    frequency_hz = as.numeric(frequency_hz),
    amplitude_db_hz = as.numeric(amplitude_db_hz),
    spectrum_group = nasality,
    
    speaker = sub(
      "^(l[12]_spk[0-9]+).*",
      "\\1",
      token
    ),
    
    speaker_number = as.numeric(
      sub(
        "^l[12]_spk0*",
        "",
        speaker
      )
    )
  ) %>%
  filter(
    speaker_number %in% reference_speakers
  )


# Read Task 04

task04 <- read_excel(
  task04_file
)

task04 <- task04 %>%
  mutate(
    frequency_hz = as.numeric(frequency_hz),
    amplitude_db_hz = as.numeric(amplitude_db_hz),
    spectrum_group = "target",
    
    speaker = sub(
      "^(l[12]_spk[0-9]+).*",
      "\\1",
      token
    ),
    
    speaker_number = as.numeric(
      sub(
        "^l[12]_spk0*",
        "",
        speaker
      )
    )
  ) %>%
  
  # Keep only the same five speakers
  filter(
    speaker_number %in% reference_speakers
  )


# Check speakers in both datasets

print(
  task01 %>%
    distinct(
      speaker,
      speaker_number
    )
)

print(
  task04 %>%
    distinct(
      speaker,
      speaker_number
    )
)


# Center each Task 01 spectrum

task01 <- task01 %>%
  group_by(token) %>%
  mutate(
    amplitude = amplitude_db_hz -
      mean(
        amplitude_db_hz,
        na.rm = TRUE
      )
  ) %>%
  ungroup()


# Center each Task 04 spectrum

task04 <- task04 %>%
  group_by(token) %>%
  mutate(
    amplitude = amplitude_db_hz -
      mean(
        amplitude_db_hz,
        na.rm = TRUE
      )
  ) %>%
  ungroup()


# Calculate Task 01 reference means

task01_means <- task01 %>%
  group_by(
    vowel_base,
    spectrum_group,
    frequency_hz
  ) %>%
  summarise(
    amplitude = mean(
      amplitude,
      na.rm = TRUE
    ),
    .groups = "drop"
  )


# Calculate Task 04 target means

task04_means <- task04 %>%
  group_by(
    vowel_base,
    spectrum_group,
    frequency_hz
  ) %>%
  summarise(
    amplitude = mean(
      amplitude,
      na.rm = TRUE
    ),
    .groups = "drop"
  )


# Combine all mean spectra

all_means <- bind_rows(
  task01_means,
  task04_means
)

all_means$spectrum_group <- factor(
  all_means$spectrum_group,
  levels = c(
    "oral",
    "nasal",
    "target"
  )
)


# Plot 1: Individual Task 04 spectra with Task 01 reference means


p1_overlay_individual <- ggplot() +
  
  # Individual Task 04 target spectra
  geom_line(
    data = task04,
    aes(
      x = frequency_hz,
      y = amplitude,
      group = token
    ),
    alpha = 0.08
  ) +
  
  # Mean Task 01 oral and nasal reference spectra
  geom_smooth(
    data = task01_means,
    aes(
      x = frequency_hz,
      y = amplitude,
      colour = spectrum_group
    ),
    method = "loess",
    span = 0.10,
    se = FALSE,
    linewidth = 1
  ) +
  
  facet_wrap(
    ~vowel_base
  ) +
  
  labs(
    title = "Task 04 spectra and Task 01 references",
    subtitle = "Black lines: individual Task 04 tokens",
    x = "Frequency (Hz)",
    y = "Centered amplitude (dB)",
    colour = "Reference"
  ) +
  
  theme_bw()

print(
  p1_overlay_individual
)


# Plot 2: Mean Task 01 oral, Task 01 nasal and Task 04 target spectra

p2_overlay_mean <- ggplot(
  all_means,
  aes(
    x = frequency_hz,
    y = amplitude,
    colour = spectrum_group
  )
) +
  
  geom_smooth(
    method = "loess",
    span = 0.10,
    se = FALSE,
    linewidth = 1.2
  ) +
  
  facet_wrap(
    ~vowel_base
  ) +
  
  scale_colour_manual(
    values = c(
      oral = "#F8766D",
      nasal = "#00BFC4",
      target = "#619CFF"
    ),
    labels = c(
      oral = "Task 01 oral",
      nasal = "Task 01 nasal",
      target = "Task 04 target"
    )
  ) +
  
  labs(
    title = "Task 01 references and Task 04 spectra",
    x = "Frequency (Hz)",
    y = "Mean centered amplitude (dB)",
    colour = "Spectrum"
  ) +
  
  theme_bw()

print(
  p2_overlay_mean
)


# GAMMs: speaker-level mean spectral curves

library(mgcv)
library(dplyr)
library(writexl)
library(ggplot2)


# Prepare combined spectral data and restrict analysis to the five reference speakers

reference_speakers <- c(1, 2, 6, 8, 13)

gamm_data <- bind_rows(
  
  task01 %>%
    transmute(
      token = token,
      vowel_base = vowel_base,
      frequency_hz = frequency_hz,
      amplitude = amplitude,
      group = spectrum_group,
      speaker = sub(
        "^(l[12]_spk[0-9]+).*",
        "\\1",
        token
      )
    ),
  
  task04 %>%
    transmute(
      token = token,
      vowel_base = vowel_base,
      frequency_hz = frequency_hz,
      amplitude = amplitude,
      group = "target",
      speaker = sub(
        "^(l[12]_spk[0-9]+).*",
        "\\1",
        token
      )
    )
  
) %>%
  mutate(
    speaker_number = as.numeric(
      sub(
        "^l[12]_spk0*",
        "",
        speaker
      )
    )
  ) %>%
  filter(
    speaker_number %in% reference_speakers
  ) %>%
  mutate(
    group = factor(group),
    speaker = factor(speaker)
  )

print(
  unique(gamm_data[, c("speaker", "speaker_number")])
)

task04 %>%
  distinct(token, vowel_base) %>%
  count(vowel_base, name = "n_tokens")


# Average spectra within speaker
# (calculate the mean amplitude at each frequency point across all
# available vowel tokens to get one mean spectral curve per
# speaker × vowel × group)

gamm_data_mean <- gamm_data %>%
  group_by(
    speaker,
    group,
    vowel_base,
    frequency_hz
  ) %>%
  summarise(
    amplitude = mean(amplitude, na.rm = TRUE),
    n_tokens = n(),
    .groups = "drop"
  ) %>%
  mutate(
    speaker = factor(speaker),
    group = factor(group)
  )


# Verification

# Number of rows after speaker-level averaging
print(
  nrow(gamm_data_mean)
)

# Check how many speakers contribute to each vowel/group
print(
  gamm_data_mean %>%
    distinct(
      speaker,
      group,
      vowel_base
    ) %>%
    count(
      vowel_base,
      group,
      name = "n_speakers"
    )
)

# Check number of frequency points per speaker/group/vowel
print(
  gamm_data_mean %>%
    count(
      speaker,
      group,
      vowel_base,
      name = "n_frequency_points"
    ) %>%
    arrange(
      vowel_base,
      group,
      speaker
    ),
  n = Inf
)

check_points <- gamm_data_mean %>%
  count(
    speaker,
    group,
    vowel_base,
    name = "n_frequency_points"
  )

print(check_points, n = Inf)


# Oral vowel (reference group) vs Task 04 target vowel
# s(frequency_hz) = oral spectral curve
# s(frequency_hz, by = group) = difference between
# Task 04 target and oral spectral shape

a_oral_target <- gamm_data_mean %>%
  filter(
    vowel_base == "a",
    group %in% c("oral", "target")
  ) %>%
  droplevels() %>%
  mutate(
    group = ordered(
      group,
      levels = c("oral", "target")
    )
  )


model_a_oral_target <- bam(
  amplitude ~
    group +
    s(
      frequency_hz
    ) +
    s(
      frequency_hz,
      by = group
    ) +
    s(
      speaker,
      bs = "re"
    ),
  data = a_oral_target,
  method = "fREML"
)


summary(model_a_oral_target)



# Nasal vowel (reference group) vs Task 04 target vowel
# s(frequency_hz) = nasal spectral curve
# s(frequency_hz, by = group) = difference between
# Task 04 target and nasal spectral shape

a_nasal_target <- gamm_data_mean %>%
  filter(
    vowel_base == "a",
    group %in% c("nasal", "target")
  ) %>%
  droplevels() %>%
  mutate(
    group = ordered(
      group,
      levels = c("nasal", "target")
    )
  )


model_a_nasal_target <- bam(
  amplitude ~
    group +
    s(
      frequency_hz
    ) +
    s(
      frequency_hz,
      by = group
    ) +
    s(
      speaker,
      bs = "re"
    ),
  data = a_nasal_target,
  method = "fREML"
)


summary(model_a_nasal_target)


# Function to extract GAMM results

extract_gamm_results <- function(model) {
  
  model_summary <- summary(model)
  
  
  # Parametric terms
  parametric_terms <- as.data.frame(
    model_summary$p.table
  )
  
  parametric_terms$Term <- rownames(
    parametric_terms
  )
  
  rownames(parametric_terms) <- NULL
  
  parametric_terms <- parametric_terms %>%
    select(
      Term,
      Estimate,
      `Std. Error`,
      `t value`,
      `Pr(>|t|)`
    )
  
  
  # Smooth terms
  smooth_terms <- as.data.frame(
    model_summary$s.table
  )
  
  smooth_terms$Term <- rownames(
    smooth_terms
  )
  
  rownames(smooth_terms) <- NULL
  
  smooth_terms <- smooth_terms %>%
    select(
      Term,
      edf,
      Ref.df,
      F,
      `p-value`
    )
  
  
  # General model information
  model_information <- data.frame(
    Measure = c(
      "Adjusted R-squared",
      "Deviance explained (%)",
      "Number of observations",
      "fREML score"
    ),
    Value = c(
      model_summary$r.sq,
      model_summary$dev.expl * 100,
      length(model$fitted.values),
      model$gcv.ubre
    )
  )
  
  
  list(
    Parametric_terms = parametric_terms,
    Smooth_terms = smooth_terms,
    Model_information = model_information
  )
}


# Extract GAMM results

results_a_oral_target <- extract_gamm_results(
  model_a_oral_target
)

results_a_nasal_target <- extract_gamm_results(
  model_a_nasal_target
)


# Export GAMM results

write_xlsx(
  
  list(
    
    a_oral_parametric =
      results_a_oral_target$Parametric_terms,
    
    a_oral_smooths =
      results_a_oral_target$Smooth_terms,
    
    a_oral_model_info =
      results_a_oral_target$Model_information,
    
    a_nasal_parametric =
      results_a_nasal_target$Parametric_terms,
    
    a_nasal_smooths =
      results_a_nasal_target$Smooth_terms,
    
    a_nasal_model_info =
      results_a_nasal_target$Model_information
    
  ),
  
  gamm_output_file
)


# Predicted GAMM curves:oral vowel vs Task 04 target vowel

new_a_oral <- expand.grid(
  
  frequency_hz = seq(
    min(
      a_oral_target$frequency_hz,
      na.rm = TRUE
    ),
    max(
      a_oral_target$frequency_hz,
      na.rm = TRUE
    ),
    length.out = 300
  ),
  
  group = c(
    "oral",
    "target"
  ),
  
  
  speaker = levels(
    a_oral_target$speaker
  )[1]
)


new_a_oral$group <- ordered(
  new_a_oral$group,
  levels = c(
    "oral",
    "target"
  )
)


pred_a_oral <- predict(
  model_a_oral_target,
  newdata = new_a_oral,
  se.fit = TRUE,
  exclude = "s(speaker)"
)


new_a_oral$fit <- pred_a_oral$fit

new_a_oral$lower <-
  pred_a_oral$fit -
  1.96 * pred_a_oral$se.fit

new_a_oral$upper <-
  pred_a_oral$fit +
  1.96 * pred_a_oral$se.fit


p_a_oral <- ggplot(
  new_a_oral,
  aes(
    x = frequency_hz,
    y = fit,
    colour = group,
    fill = group
  )
) +
  
  geom_ribbon(
    aes(
      ymin = lower,
      ymax = upper
    ),
    alpha = 0.15,
    colour = NA
  ) +
  
  geom_line(
    linewidth = 1.1
  ) +
  
  scale_colour_manual(
    values = c(
      oral = "#F8766D",
      target = "#619CFF"
    ),
    labels = c(
      oral = "Task 01 oral",
      target = "Task 04 target"
    )
  ) +
  
  scale_fill_manual(
    values = c(
      oral = "#F8766D",
      target = "#619CFF"
    ),
    guide = "none"
  ) +
  
  labs(
    title = "GAMM fitted spectra: /a/",
    subtitle = "Task 01 oral vs Task 04 target",
    x = "Frequency (Hz)",
    y = "Predicted centered amplitude (dB)",
    colour = "Spectrum"
  ) +
  
  theme_bw()


print(p_a_oral)


# Predicted GAMM curves: nasal vowel vs Task 04 target vowel

new_a_nasal <- expand.grid(
  
  frequency_hz = seq(
    min(
      a_nasal_target$frequency_hz,
      na.rm = TRUE
    ),
    max(
      a_nasal_target$frequency_hz,
      na.rm = TRUE
    ),
    length.out = 300
  ),
  
  group = c(
    "nasal",
    "target"
  ),
  
  
  speaker = levels(
    a_nasal_target$speaker
  )[1]
)


new_a_nasal$group <- ordered(
  new_a_nasal$group,
  levels = c(
    "nasal",
    "target"
  )
)


pred_a_nasal <- predict(
  model_a_nasal_target,
  newdata = new_a_nasal,
  se.fit = TRUE,
  exclude = "s(speaker)"
)


new_a_nasal$fit <- pred_a_nasal$fit

new_a_nasal$lower <-
  pred_a_nasal$fit -
  1.96 * pred_a_nasal$se.fit

new_a_nasal$upper <-
  pred_a_nasal$fit +
  1.96 * pred_a_nasal$se.fit


p_a_nasal <- ggplot(
  new_a_nasal,
  aes(
    x = frequency_hz,
    y = fit,
    colour = group,
    fill = group
  )
) +
  
  geom_ribbon(
    aes(
      ymin = lower,
      ymax = upper
    ),
    alpha = 0.15,
    colour = NA
  ) +
  
  geom_line(
    linewidth = 1.1
  ) +
  
  scale_colour_manual(
    values = c(
      nasal = "#00BFC4",
      target = "#619CFF"
    ),
    labels = c(
      nasal = "Task 01 nasal",
      target = "Task 04 target"
    )
  ) +
  
  scale_fill_manual(
    values = c(
      nasal = "#00BFC4",
      target = "#619CFF"
    ),
    guide = "none"
  ) +
  
  labs(
    title = "GAMM fitted spectra: /a/",
    subtitle = "Task 01 nasal vs Task 04 target",
    x = "Frequency (Hz)",
    y = "Predicted centered amplitude (dB)",
    colour = "Spectrum"
  ) +
  
  theme_bw()


print(p_a_nasal)
