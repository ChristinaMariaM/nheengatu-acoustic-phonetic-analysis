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

**Output:** Vowel-space plots and the following files, saved in the current working directory:

- `task02_kmeans_classified_tokens.csv` – token-level formant measurements, cluster assignments, and silhouette widths.
- `task02_kmeans_cluster_summary.csv` – descriptive statistics for each acoustic cluster.
- `task02_kmeans_cluster_centres.csv` – cluster centers in Hz and token counts.
- `task02_kmeans_vowel_space.png` – vowel-space plot showing the two clusters and their centers.
