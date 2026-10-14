# nheengatu-acoustic-phonetic-analysis
R and Praat scripts for the acoustic-phonetic analysis of Nheengatu speech data

## R scripts

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

**Script:** `task_04_spectral_descriptive_statistics.R`

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


### Task 04 – Spectra and GAMM

**Script:** `task_04_spectra_and_gamm.R`

This script analyzes spectral measurements from Task 1 and Task 4 to investigate the acoustic characteristics of vowels in /Vnd/ sequences relative to phonologically oral and nasal reference vowels. The analysis is restricted to five reference speakers (1, 2, 6, 8, and 13). Individual spectra are centered by subtracting the mean amplitude of each token, and mean spectral curves are calculated for each vowel and group.

The script generates visual comparisons of individual and mean spectra from Task 1 and Task 4. It subsequently calculates speaker-level mean spectral curves and fits generalized additive mixed models (GAMMs) using the `mgcv` package. The models included in this script compare Task 4 /a/ spectra separately with Task 1 oral /a/ and nasal /ã/ reference spectra. Frequency-dependent spectral differences are modeled using smooth terms, with speaker included as a random effect. Model summaries are exported, and predicted spectral curves with 95% confidence intervals are plotted.

**Required input files:**
- `task01_file`: Task 1 spectral measurements (`task01_spectra.xlsx`), containing phonologically oral and nasal reference vowels.
- `task04_file`: Task 4 spectral measurements (`task04_spectra.xlsx`), containing vowels from /Vnd/ sequences.

Both input files are read using the `readxl` package.

**File paths and execution:**

The script does not contain the original local file paths used during the analysis. These have been replaced with placeholders to avoid publishing personal directory information. To execute the script, users must specify the locations of the two corresponding input files in the `task01_file` and `task04_file` variables defined at the beginning of the script. The input data are not included in this repository.

The `gamm_output_file` variable specifies the location and filename of the Excel workbook containing the GAMM results. Users must provide a valid output path before executing the script.

**Software requirements:** R with the `readxl`, `dplyr`, `ggplot2`, `mgcv`, and `writexl` packages.

**Output:** Spectral visualizations and GAMM results, including:

- Individual oral and nasal reference spectra from Task 1, grouped by vowel.
- Mean oral and nasal reference spectra from Task 1, grouped by vowel.
- Individual Task 4 spectra overlaid with Task 1 reference curves.
- Mean spectral curves comparing Task 1 oral, Task 1 nasal, and Task 4 target vowels.
- GAMM results for Task 4 /a/ compared with Task 1 oral /a/ and nasal /ã/, including parametric terms, smooth terms, and model information.
- Predicted GAMM spectral curves with 95% confidence intervals for both comparisons.

The GAMM results are exported to `GAMM_results_a.xlsx` (or the filename specified in `gamm_output_file`). The plots are displayed in R but are not automatically saved as image files.


### Task 04 – Nasal consonant durations

**Script:** `task_04_n_durations.R`

This script calculates descriptive statistics for the duration of /n/ in the four Task 4 sequences /and/, /end/, /ind/, and /und/. It processes duration measurements from an Excel spreadsheet and calculates the number of valid observations, mean, median, standard deviation, minimum, and maximum duration (in milliseconds) for each sequence and for all four sequences combined. Duration values are rounded to one decimal place in the final summary table.

**Required input file:**
- `file_path`: Task 4 nasal consonant duration measurements (`n_durations.xlsx`), containing the sequence labels (`item`) and duration values in milliseconds (`n_duration_ms`).

The input file is read using the `readxl` package.

**File paths and execution:**

The script does not contain the original local file paths used during the analysis. These have been replaced with placeholders to avoid publishing personal directory information. To execute the script, users must specify the location of the corresponding input spreadsheet in the `file_path` variable and the desired output location in the `output_path` variable. The input data are not included in this repository.

**Software requirements:** R with the `readxl`, `dplyr`, and `writexl` packages.


### Task 04 – Effect of speech style on nasalization

**Script:** `task_04_speech_style_nasalization.R`

This script investigates the effect of speech style on acoustic measures associated with nasalization in Task 4, comparing read speech (Task 04a) and spontaneous speech (Task 04b). It processes spectral-minimum and relative nasal-window energy measurements, calculates descriptive statistics, and generates boxplots showing the distribution of individual tokens across speech styles.

Three acoustic measures are analyzed: relative nasal-window energy (dB), local spectral-minimum energy (dB), and local spectral-minimum frequency (Hz). For each measure, the script calculates speaker-level mean values and performs a paired Wilcoxon signed-rank test to compare read and spontaneous speech. Additional paired plots illustrate the differences between speech styles for individual speakers.

**Required input files:**
- `anti_file`: Task 04 spectral-minimum measurement CSV, containing local spectral-minimum frequencies (`minFreq_Hz`) and energies (`minEnergy_dB`).
- `band_file`: Task 04 relative nasal-window energy measurement CSV, containing relative spectral band energy values (`relativeBandEnergy_dB`).

Both input files must contain observations from Task 04a and Task 04b, identifiable through the `file` column. They are read as semicolon-delimited CSV files.

**File paths and execution:**

The script does not contain personal local file paths. Instead, the `file.choose()` function allows users to select the two required input files interactively when executing the script. The input data are not included in this repository.

All exported files are saved in the current R working directory.

**Software requirements:** R with the `tidyverse` package.

**Output:** Descriptive statistics, statistical test results, and visualizations, including:

- `task04_antiformant_summary.csv` – descriptive statistics for local spectral-minimum energy and frequency by speech style.
- `task04_band_energy_summary.csv` – descriptive statistics for relative nasal-window energy by speech style.
- `task04_wilcoxon_summary.csv` – Wilcoxon signed-rank test statistics and p-values for all three acoustic measures.
- Three token-level boxplots comparing read and spontaneous speech.
- Three paired speaker-level plots illustrating differences between speech styles.

The CSV files are saved in the current working directory. The plots are displayed in R but are not automatically exported as image files.

**Output:** One Excel spreadsheet:

- `n_duration_summary.xlsx` – descriptive statistics for /n/ duration by sequence and overall, including observation counts, mean, median, standard deviation, minimum, and maximum duration in milliseconds.

The output file is saved to the location specified in `output_path`.


## Praat scripts

### Tasks 01 and 02 – Vowel extraction

**Script:** `task_01_02_vowel_extraction.praat`

**Original script:** Prof. Volker Dellwo, University of Zurich  
**Study-specific adaptation:** Christina Müller

This Praat script automatically extracts annotated vowel intervals from recordings and their corresponding TextGrid files. Based on a script developed by Prof. Volker Dellwo, it was adapted for Tasks 01 and 02 to restrict extraction to predefined vowel labels and number successfully extracted vowels consecutively.

The script processes the first TextGrid tier and accepts only the labels `a`, `e`, `i`, `o`, `u`, `ã`, `ẽ`, `ĩ`, `õ`, and `ũ`. Spaces and tab characters are removed from interval labels before checking them. Other labels and empty intervals are excluded.

Extracted vowels are numbered consecutively within each recording, starting at `01`, independently of their original interval numbers. Sound intervals are extracted using the annotated boundaries, without adjustment to nearby zero crossings.

**Required input files:**
- WAV recordings containing the speech material.
- Corresponding Praat TextGrid files with vowel annotations on the first tier.

Each WAV file must have a corresponding TextGrid file with the same basename.

**File paths and execution:**

The variables `rDir$` and `wDir$` specify the input and output directories, respectively. These paths must be adjusted to the user's local directory structure before execution. The output directory must already exist.

**Software requirements:** Praat.

**Output:** Individual WAV files and corresponding TextGrid files for each accepted vowel interval. Filenames retain the original recording basename and append a consecutive vowel number (e.g., `recording_01.wav` and `recording_01.TextGrid`).

The recordings and annotations used in the present study are not included in this repository.


### Task 04 – Vowel extraction from /Vnd/ sequences

**Script:** `task_04_vowel_extraction_reconstructed.praat`

**Original script:** Prof. Volker Dellwo, University of Zurich  
**Study-specific adaptation:** Christina Müller

This Praat script automatically extracts the vowel interval from annotated three-segment sequences corresponding to *and*, *end*, *ind*, and *und*. It is based on the extraction script developed by Prof. Volker Dellwo and was adapted for Task 04 of the present study.

The script examines the first tier of each TextGrid and identifies sequences in which a vowel labelled `a`, `e`, `i`, or `u` is immediately followed by intervals labelled `n` and `d`. Only the vowel interval is extracted; the consonantal intervals are excluded. Any additional TextGrid tiers are ignored for interval selection.

Successfully extracted vowels are numbered consecutively within each recording, starting at `01`. The Sound intervals are extracted using their annotated boundaries, without adjustment to nearby zero crossings.

**Required input files:**
- WAV recordings from Task 04a (read speech) and/or Task 04b (spontaneous speech).
- Corresponding Praat TextGrid files containing the separately annotated vowel, /n/, and /d/ intervals on the first tier.

Each WAV file must have a corresponding TextGrid file with the same basename.

**File paths and execution:**

The variables `rDir$` and `wDir$` specify the input and output directories, respectively. The placeholder paths must be replaced with the appropriate local directories before execution. The output directory must already exist.

**Software requirements:** Praat.

**Output:** Individual WAV files and corresponding TextGrid files containing the extracted vowel intervals. Filenames retain the original recording basename and append a consecutive vowel number and vowel label (e.g., `l1_spk01_m_baré_task04a_01_i.wav` and `l1_spk01_m_baré_task04a_01_i.TextGrid`).

The recordings and annotations used in the present study are not included in this repository.

### DatabaseExplorer – Sound file browsing and editing

**Script:** `databaseExplorer.praat`

**Author:** Prof. Volker Dellwo, University of Zurich

This open-source Praat script facilitates browsing and basic editing of Sound objects stored in the same directory. It allows users to navigate between recordings, inspect their acoustic properties, and perform basic editing operations, including the extraction and saving of selected sound segments. The tool also supports working with corresponding TextGrid annotations.

In the present study, DatabaseExplorer was used to review extracted vowel recordings and perform basic editing where necessary. The script was used without modification.

**Required input:**
- A Sound object selected in Praat, originating from a directory containing the recordings to be reviewed.

The script identifies the directory of the selected Sound object and allows navigation through other sound files with the same extension.

**File paths and execution:**

The script does not require users to specify a personal file path in the source code. It identifies the location of the selected Sound object automatically. When saving edited recordings, users can select an output directory interactively.

The recordings and annotations used in the present study are not included in this repository.

**Software requirements:** Praat.

**Output:** Interactive browsing and inspection of sound recordings, with the option to save edited Sound objects and corresponding TextGrid annotations.

**Authorship and license:**

DatabaseExplorer was developed by Prof. Volker Dellwo (University of Zurich). The original authorship information and GNU General Public License notice have been retained in the script. The version provided in this repository is identical to the original and has not been modified for the present study.
