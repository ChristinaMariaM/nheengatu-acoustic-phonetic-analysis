# nheengatu-acoustic-phonetic-analysis
R and Praat scripts for the acoustic-phonetic analysis of Nheengatu speech data

### Task 01 – Vowel formants

**Script:** `task_01_vowel_formants.R`

This script processes the formant measurements obtained in Task 1 to calculate token-level median F1 and F2 values, generate vowel-space plots, compare L1 and L2 speakers, perform speaker-intrinsic Lobanov normalization, and calculate descriptive statistics. It also incorporates a separately extracted set of corrected measurements for /ũ/.

**Required input files:**
- `main_file`: Task 1 formant measurement table (`ALL_formant_measurements.Table`), containing the original measurements.
- `u_nasal_file`: Separately extracted formant measurement table (`ALL_formant_measurements.Table`), containing the corrected /ũ/ measurements.

Both input files are read using UTF-16 encoding.

**File paths and execution:**

The script does not contain the original local file paths used during the analysis. These have been replaced with placeholders to avoid publishing personal directory information. To execute the script, users must specify the locations of the corresponding input files in the two variables defined at the beginning of the script. The input data are not included in this repository.

**Software requirements:** R with the `tidyverse` package (including `dplyr` and `ggplot2`).

**Output:** Vowel-space plots and two CSV files containing descriptive statistics for the main vowel measurements and the corrected /ũ/ measurements. The CSV files are saved in the current working directory.


### Task 02 – Vowel formants

**Script:** `task_02_vowel_formants.R`

This script processes the formant measurements obtained in Task 2 to calculate token-level median F1 and F2 values, generate vowel-space plots, and investigate the acoustic distribution of possible /u/ and /o/ realizations using k-means clustering. The clustering procedure standardizes F1 and F2, applies a predefined acoustic window (F1: 200–700 Hz; F2: 500–1400 Hz), and identifies two clusters labeled *u-like* and *o-like*. Cluster separation is evaluated using the average silhouette width.

**Required input file:**
- `task02_file`: Task 2 formant measurement table (`ALL_formant_measurements.Table`), containing the extracted F1 and F2 measurements.

The input file is read using UTF-16 encoding.

**File paths and execution:**

The script does not contain the original local file path used during the analysis. It has been replaced with a placeholder to avoid publishing personal directory information. To execute the script, users must specify the location of the corresponding input file in the `task02_file` variable defined at the beginning of the script. The input data are not included in this repository.

**Software requirements:** R with the `tidyverse` and `cluster` packages.


### Task 03 – Descriptive and inferential statistics

**Script:** `task_03_descriptive_and_inferential_statistics.R`

This script analyzes glottal-stop occurrence in Task 3 using manually annotated observations. It processes the annotation spreadsheet, calculates the frequency and percentage of glottal-stop occurrences by lexical item, speaker group (L1/L2), and age, and generates a bar chart illustrating the distribution across lexical items. Inferential analyses include a chi-square test or Fisher's exact test, depending on expected cell frequencies, and a logistic mixed-effects model investigating the association between L1/L2 speaker status and glottal-stop occurrence, with speaker included as a random intercept.

**Required input file:**
- `file_name`: Task 3 annotation spreadsheet (`task_03_glottal_stop_counts.xlsx`), containing speaker information and manually coded glottal-stop observations.

The input file is read using the `readxl` package.

**File paths and execution:**

The script does not contain the original local file path used during the analysis. It has been replaced with a placeholder to avoid publishing personal directory information. To execute the script, users must specify the location of the corresponding Excel spreadsheet in the `file_name` variable defined at the beginning of the script. The input data are not included in this repository.

The output directory is automatically determined from the location of the input spreadsheet using `dirname(file_name)`. All generated files are saved in that directory.

**Software requirements:** R with the `readxl`, `dplyr`, `tidyr`, `ggplot2`, `lme4`, and `stringr` packages.

**Output:** Descriptive summaries, statistical test results, model results, and a visualization, saved as the following files:

- `task03_glottal_stop_summary_by_word.csv` – glottal-stop counts and percentages by lexical item.
- `task03_glottal_stop_summary_by_group.csv` – glottal-stop counts and percentages for L1 and L2 speakers.
- `task03_glottal_stop_summary_by_age.csv` – glottal-stop counts and percentages by age.
- `task03_glottal_stop_complete_summary.txt` – combined descriptive summaries.
- `task03_glottal_stop_barplot.png` – bar chart showing glottal-stop occurrence by lexical item.
- `task03_glottal_stop_test_results.txt` – contingency table and chi-square or Fisher's exact test results.
- `task03_glottal_L1_status_model_summary.txt` – logistic mixed-effects model summary.
- `task03_glottal_L1_status_fixed_effects.csv` – fixed-effect estimates, significance tests, and odds ratios.
- `task03_glottal_L1_status_random_effects.csv` – random-effect estimates.
- `task03_glottal_L1_status_model_info.csv` – model diagnostics and fit statistics.
**Output:** Vowel-space plots and the following files, saved in the current working directory:

- `task02_kmeans_classified_tokens.csv` – token-level formant measurements, cluster assignments, and silhouette widths.
- `task02_kmeans_cluster_summary.csv` – descriptive statistics for each acoustic cluster.
- `task02_kmeans_cluster_centres.csv` – cluster centers in Hz and token counts.
- `task02_kmeans_vowel_space.png` – vowel-space plot showing the two clusters and their centers.


### Task 04 – Spectral-energy measures

**Script:** `task_04_spectral_energy_measures.R`

This script processes spectral measurements obtained from Task 4 /Vnd/ vowels and phonologically nasal reference vowels from Task 1. It calculates descriptive statistics and generates boxplots comparing the two groups across four acoustic measures: local spectral-minimum frequency (Hz), local spectral-minimum energy (dB), relative spectral band energy (raw ratio), and relative nasal-window energy (dB). For each measure and group, the script calculates the number of valid observations, mean, median, and standard deviation.

**Required input files:**
- `oral_antiformant_path`: Task 4 spectral-minimum measurements (`antiformant_candidates_task04.csv`).
- `nasal_antiformant_path`: Task 1 phonologically nasal reference measurements (`antiformant_candidates_task01_nasal.csv`).
- `oral_band_path`: Task 4 relative nasal-window energy measurements (`relative_nasal_window_energy_task04.csv`).
- `nasal_band_path`: Task 1 phonologically nasal reference energy measurements (`relative_nasal_window_energy_task01_nasal.csv`).

All four input files are read as semicolon-delimited CSV files. The two Task 1 reference files are explicitly read using UTF-16BE encoding.

**File paths and execution:**

The script does not contain the original local file paths used during the analysis. These have been replaced with placeholders to avoid publishing personal directory information. To execute the script, users must specify the locations of the four corresponding input files in the path variables defined at the beginning of the script. The input data are not included in this repository.

All output files are saved in the current R working directory.

**Software requirements:** R with the `tidyverse` package.

**Output:** Descriptive statistics and boxplots, saved as the following files:

- `task04_spectral_descriptive_statistics.csv` – combined descriptive statistics for all four acoustic measures.
- `task04_local_spectral_minimum_frequency_summary.csv` – descriptive statistics for local spectral-minimum frequency.
- `task04_local_spectral_minimum_energy_summary.csv` – descriptive statistics for local spectral-minimum energy.
- `task04_relative_band_energy_raw_summary.csv` – descriptive statistics for relative spectral band energy (raw ratio).
- `task04_relative_nasal_window_energy_summary.csv` – descriptive statistics for relative nasal-window energy (dB).
- `boxplot_local_spectral_minimum_frequency.png` – comparison of local spectral-minimum frequencies.
- `boxplot_local_spectral_minimum_energy_dB.png` – comparison of local spectral-minimum energies.
- `boxplot_relative_band_energy.png` – comparison of relative spectral band energy (raw ratio).
- `boxplot_relative_nasal_window_energy_dB.png` – comparison of relative nasal-window energy (dB).
