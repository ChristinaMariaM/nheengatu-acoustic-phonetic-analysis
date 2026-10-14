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


### Task 01 – Automated vowel formant measurements

**Script:** `task_01_makeTable.praat`

**Supporting script:** `function_findBestPitchAndFormant.praat`

**Authorship:** Original script developed by Prof. Volker Dellwo (University of Zurich) and adapted by Christina Müller for Task 01.

This Praat script performs automated acoustic measurements of the vowel segments extracted for Task 01. It processes individual vowel WAV files and calls `function_findBestPitchAndFormant.praat` to obtain pitch and formant measurements using an automated procedure for selecting the optimal formant ceiling.

Only vowel files longer than 40 ms are processed. The script extracts metadata from the filenames, including speaker, language status, sex, ethnicity, task, item number, and vowel identity. Pitch ceilings are set to 400 Hz for male speakers and 500 Hz for female speakers.

**Required input files:**
- Individual vowel WAV files extracted for Task 01.
- `function_findBestPitchAndFormant.praat`, which must be accessible to the main script.

**File paths and execution:**

The variable `rDir$` specifies the directory containing the extracted vowel WAV files and must be adjusted to the user's local file structure.

The supporting function is called automatically for each eligible vowel file. The script creates timestamped output subdirectories within `tables/` and `pics/`, relative to the working directory.

**Software requirements:** Praat (versions 6.4.17 and 6.6.30 were used in the present study).

**Output:** Individual tab-separated Praat measurement tables, corresponding PNG visualizations, and a combined table named `ALL_formant_measurements.Table`, containing the acoustic measurements and filename-derived metadata for all processed vowels.

The recordings and measurement tables used in the present study are not included in this repository.


### Tasks 01 and 02 – Automated pitch and formant measurement function

**Script:** `function_findBestPitchAndFormant.praat`

**Author:** Prof. Volker Dellwo, University of Zurich

This Praat script implements the automated acoustic measurement procedure used for Tasks 01 and 02. It processes individual vowel Sound objects and estimates pitch and formant values, including an automated search across a specified range of formant ceilings.

The function applies temporal padding to the vowel segment, performs pitch analysis, and evaluates formant estimates obtained with different ceiling settings. It returns acoustic measurements in a Praat table and can generate diagnostic visualizations.

In the present study, the function was called by `task_01_makeTable.praat` for the initial Task 01 measurements, by `task_02_makeTable.praat` for Task 02 measurements, and by `task_01_reanalyze_u_nasal.praat` for the selective reanalysis of 11 nasal /ũ/ tokens. The formant-ceiling range and other analysis parameters are passed to the function by the calling scripts.

**Required input:**
- An individual vowel Sound object supplied automatically by the calling script.

**File paths and execution:**

The function does not require a dataset-specific input directory. It is called using `runScript`, with the relevant analysis parameters supplied as arguments.

The function must be accessible under the filename `function_findBestPitchAndFormant.praat` at the path specified in the calling script.

**Software requirements:** Praat. The original script was developed using version 6.4.17; versions 6.4.17 and 6.6.30 were used in the present study.

**Output:** A Praat table containing pitch and formant measurements, with optional diagnostic visualizations. The calling scripts handle the saving and compilation of the results.

**Authorship and license:** The function was developed by Prof. Volker Dellwo and retains its original GNU General Public License notice.


### Task 01 – Reanalysis of selected nasal /ũ/ tokens

**Script:** `task_01_reanalyze_u_nasal.praat`

**Supporting script:** `function_findBestPitchAndFormant.praat`

This Praat script selectively reanalyzes 11 nasal /ũ/ tokens that showed unexpectedly high F2 values (above 2000 Hz) during the initial formant analysis. The affected tokens were identified through visual inspection of the vowel space and subsequent examination of their formant tracks and spectrograms in Praat.

The reanalysis uses the same automated formant-measurement procedure and settings as the initial analysis, except for the range of formant ceilings considered. The optimal ceiling is selected from **4900 to 5000 Hz in 10-Hz increments**, rather than the wider range used in the initial analysis. This restriction was introduced to reduce LPC tracking errors associated with excessively high formant ceilings.

The resulting measurements were used to replace the original values of the 11 affected tokens in the final Task 01 dataset.

**Required input files:**
- The 11 selected vowel WAV files from Task 01.
- `function_findBestPitchAndFormant.praat`, which implements the automated measurement procedure.

**File paths and execution:**

The script contains a predefined list of the 11 affected vowel filenames. The input directory must be adjusted to the user's local file structure, and the supporting function script must be accessible at the path specified in the main script.

The formant ceiling arguments must be set to `4900`, `5000`, and `10` (minimum, maximum, and increment, respectively) to reproduce the reanalysis described here.

**Software requirements:** Praat.

**Output:** A Praat table containing the remeasured acoustic values for the 11 selected /ũ/ tokens, for incorporation into the final Task 01 formant dataset.

The original recordings, extracted vowel files, and measurement tables are not included in this repository.


### Task 02 – Preliminary vowel-space analysis

**Script:** `task_02_formants.praat`

**Purpose:** Extraction of F1 and F2 measurements at vowel midpoints for the preliminary acoustic analysis of Task 02.

This Praat script extracts F1 and F2 measurements at the temporal midpoint of annotated intervals in Tier 1 of the corresponding TextGrid files. The measurements were used to create an initial vowel-space plot of tokens previously classified auditorily as /u/ or /o/.

The script processes WAV files and their corresponding TextGrid annotations using Praat's Burg formant analysis. The default settings specify five formants and a maximum formant frequency of 5500 Hz. For each interval with a positive duration, the script calculates its midpoint and extracts the corresponding F1 and F2 values.

Unlike the subsequent automated formant-analysis procedure (`task_02_makeTable.praat`), this script retains the original interval labels, allowing the preliminary measurements to be examined in relation to the auditory classifications.

**Required input files:**
- WAV files containing the Task 02 recordings.
- Corresponding TextGrid files with annotated intervals in Tier 1.

**File paths and execution:**

The script uses a configurable input folder, which must be adjusted to the user's local file structure. The folder must contain WAV files and their corresponding TextGrid files with matching basenames.

The analysis parameters, including the annotation tier, maximum formant frequency, and number of formants, can be adjusted in the script's input form.

**Software requirements:** Praat (versions 6.4.17 and 6.6.30 were used in the present study).

**Output:** A tab-separated file named `task02_formants_all_intervals.tsv`, saved in the input directory. The table contains the source filename, interval number, original annotation label, start and end times, duration, temporal midpoint, and F1 and F2 measurements.

The recordings, TextGrid annotations, and measurement tables used in the present study are not included in this repository.


### Task 02 – Automated vowel formant measurements

**Script:** `task_02_makeTable.praat`

**Supporting script:** `function_findBestPitchAndFormant.praat`

**Authorship:** Original script developed by Prof. Volker Dellwo (University of Zurich) and adapted by Christina Müller for Task 02.

This Praat script performs automated acoustic measurements of the vowel segments extracted for Task 02. It processes individual vowel WAV files and calls `function_findBestPitchAndFormant.praat` to obtain pitch and formant measurements using the same automated procedure as in Task 01, including the selection of the optimal formant ceiling.

Only vowel files longer than 40 ms are processed. The script extracts metadata from the filenames, including language group, speaker, sex, ethnicity, task, and item number. Unlike the Task 01 version, it does not extract or include a vowel-category variable, ensuring that the subsequent acoustic analysis is independent of the previous auditory classification. Pitch ceilings are set to 400 Hz for male speakers and 500 Hz for female speakers.

**Required input files:**
- Individual vowel WAV files extracted for Task 02.
- `function_findBestPitchAndFormant.praat`, which must be accessible to the main script.

**File paths and execution:**

The variable `rDir$` specifies the directory containing the extracted vowel WAV files and must be adjusted to the user's local file structure.

The supporting function is called automatically for each eligible vowel file. The script creates timestamped output subdirectories within `tables/` and `pics/`, relative to the working directory.

**Software requirements:** Praat (versions 6.4.17 and 6.6.30 were used in the present study).

**Output:** Individual tab-separated Praat measurement tables, corresponding PNG visualizations, and a combined table named `ALL_formant_measurements.Table`, containing the acoustic measurements and filename-derived metadata for all processed vowels. The combined table is subsequently imported into R for further analysis.

The recordings and measurement tables used in the present study are not included in this repository.


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


### Task 04 – Vowel formants and duration

**Script:** `task_04_f1_f2_duration.praat`

This script automatically measures F1, F2, and vowel duration for the Task 04 vowel segments. Formant frequencies are obtained at the temporal midpoint of each annotated vowel using Praat's Burg formant analysis, minimizing the influence of adjacent consonantal transitions.

**Required input files:**
- Task 04 WAV files.
- Corresponding TextGrid files containing the annotated vowel intervals.

**File paths and execution:**

The `Data_folder` parameter specifies the directory containing the WAV and TextGrid files. The `Output_file` parameter specifies the destination of the measurement table. Both must be adjusted to the user's local file structure.

The script processes nonempty intervals in the selected annotation tier. The number of formants and maximum formant frequency can be configured in the input form.

**Software requirements:** Praat (versions 6.4.17 and 6.6.30 were used in the present study).

**Output:** A semicolon-separated CSV file containing the source filename, vowel label, interval boundaries, duration, midpoint, and F1/F2 measurements.


### Task 04 – Local spectral-minimum analysis

**Script:** `antiformant_candidates.praat`

This script estimates the frequency and magnitude of the lowest local spectral-energy point within a predefined frequency window, providing an exploratory measure of spectral attenuation potentially associated with nasalization.

The analysis uses the central 50% of each vowel interval to reduce the influence of adjacent consonantal transitions. Within the **540–1720 Hz** search window, spectral energy is measured in 80-Hz bands at 10-Hz increments. The frequency associated with the lowest energy is retained together with its energy value.

The script does not identify confirmed antiformants; its measurements are interpreted as local spectral minima.

The search window was established from the F1–F2 region of a sample of phonologically nasal Task 01 vowels, as described in the thesis methodology.

**Required input files:**
- Individual vowel WAV files from Task 04 or phonologically nasal reference vowels from Task 01.
- Corresponding TextGrid files containing the vowel annotations.

**File paths and execution:**

The `Data_folder` parameter specifies the directory containing matching WAV and TextGrid files. The `Output_file` parameter specifies the destination of the results. Both paths must be adjusted to the user's local file structure.

The script processes the first nonempty interval in the selected tier of each file.

**Software requirements:** Praat.

**Output:** A semicolon-separated CSV file containing the source filename, vowel label, analyzed interval boundaries, search-window identifier, frequency of minimum spectral energy, raw minimum energy, and its logarithmic representation.


### Task 04 – Relative nasal-window energy

**Script:** `band_energy_relative.praat`

This script measures relative spectral energy within the predefined **540–1720 Hz** nasal-window frequency range.

For each vowel, the central 50% of the annotated interval is extracted to reduce the influence of consonantal transitions. Spectral energy within the nasal window is calculated relative to the total spectral energy between 0 and 5000 Hz. The resulting ratio is also expressed on a logarithmic (dB) scale.

Unlike absolute band energy, this relative measure reduces the influence of differences in recording amplitude. The procedure was used to compare Task 04 vowels with phonologically nasal reference vowels from Task 01 and to investigate potential differences between read and spontaneous speech.

**Required input files:**
- Individual vowel WAV files from Task 04 or phonologically nasal reference vowels from Task 01.
- Corresponding TextGrid files containing the vowel annotations.

**File paths and execution:**

The `Data_folder` parameter specifies the input directory, and `Output_file` specifies the destination of the results. Both paths must be adjusted to the user's local file structure.

The script processes the first nonempty interval in the selected annotation tier of each file.

**Software requirements:** Praat.

**Output:** A semicolon-separated CSV file containing the source filename, vowel label, analyzed interval boundaries, frequency window, nasal-window energy, total spectral energy, relative energy ratio, and relative energy in dB.


### Task 04 – Nasal consonant duration

**Script:** `n_durations.praat`

This script automatically extracts the duration of the nasal consonant /n/ in the Task 04 sequences *and*, *end*, *ind*, and *und*.

The script reads the manually annotated TextGrid files and identifies sequences consisting of three consecutive intervals: a vowel (/a, e, i, u/), followed by /n/ and /d/. For each valid sequence, the duration of /n/ is calculated from its annotated onset and offset boundaries.

These measurements were used to investigate the temporal realization of the nasal consonant and assess potential consonant deletion.

**Required input files:**
- Task 04 TextGrid files with vowel–/n/–/d/ annotations in Tier 1.

**File paths and execution:**

The `textgrid_folder` parameter specifies the directory containing the annotated TextGrid files, and `output_file` specifies the destination of the results. Both paths must be adjusted to the user's local file structure.

**Software requirements:** Praat (the script specifies compatibility with version 6.6.30).

**Output:** A tab-separated TSV file containing the source filename, token number, interval number, sequence identity, vowel identity, /n/ onset and offset, and consonant duration in seconds and milliseconds.


### Task 04 – Spectral extraction of Task 01 reference vowels

**Script:** `spectrum_task_01_reference_vowels.praat`

This script extracts spectral measurements from phonologically oral and nasal Task 01 vowels selected as reference material for the Task 04 spectral comparison.

For each annotated vowel, a **40-ms window centered on the vowel midpoint** is extracted using a Hanning window. A spectrum and a long-term average spectrum (LTAS) are calculated, and amplitude values between 300 and 3000 Hz are exported.

The script distinguishes the four oral vowels /a, e, i, u/ from their phonologically nasal counterparts /ã, ẽ, ĩ, ũ/ and retains the corresponding vowel and nasality labels.

**Required input files:**
- Selected Task 01 reference-vowel WAV files.
- Corresponding TextGrid files containing vowel annotations.

**File paths and execution:**

The `input_folder` parameter specifies the directory containing the selected reference files. The `output_file` parameter specifies the destination of the spectral table. Both must be adjusted to the user's local file structure.

The annotation tier, window duration, and frequency limits can be configured in the script's input form.

**Software requirements:** Praat.

**Output:** A tab-separated TSV file containing token identifiers, vowel and nasality classifications, vowel and analysis-window boundaries, frequency values, and spectral amplitude measurements.


### Task 04 – Spectral extraction of target vowels

**Script:** `spectrum_task_04_target_vowels.praat`

This script extracts spectral measurements from the Task 04 target vowels preceding /nd/, using the same procedure as the Task 01 reference-vowel script.

For each identified target vowel, a **40-ms analysis window centered on the vowel midpoint** is extracted using a Hanning window. A spectrum and LTAS are calculated, and amplitude values between 300 and 3000 Hz are exported for subsequent analysis in R.

The script identifies target vowels /a, e, i, u/ in the annotated Task 04 material and retains the vowel identity and token metadata.

The resulting spectral measurements were used to compare Task 04 vowels with the corresponding oral and nasal reference vowels from Task 01. Spectral centering, descriptive plots, and GAMM analyses were subsequently performed in R.

**Required input files:**
- Task 04 WAV recordings containing annotated target sequences.
- Corresponding TextGrid files with the target vowel intervals.

**File paths and execution:**

The `input_folder` parameter specifies the directory containing the Task 04 recordings and annotations. The `output_file` parameter specifies the destination of the spectral table. Both must be adjusted to the user's local file structure.

The annotation tier, analysis-window duration, and frequency limits can be configured in the input form.

**Software requirements:** Praat.

**Output:** A tab-separated TSV file containing token identifiers, vowel identity, dataset label, vowel and analysis-window boundaries, frequency values, and spectral amplitude measurements.

**Data availability:** The original recordings, TextGrid annotations, and measurement tables are not included in this repository because access to the underlying speech data is restricted.
