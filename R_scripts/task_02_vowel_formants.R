###############################################################
# Task 02 - F1 and F2 boxplots, k-means
###############################################################

# INPUT FILE PATH
# Replace the placeholder with the location of the Task 2
# formant measurement table on your computer.

task02_file <- "PATH_TO_TASK02_FORMANT_TABLE"

# F1 and F2 boxplots

library(tidyverse)

data <- read.delim(
  task02_file,
  fileEncoding = "UTF-16"
)


vowel_space <- data %>%
  group_by(file, spkr, sex, task, item) %>%
  summarise(
    F1 = median(f1, na.rm = TRUE),
    F2 = median(f2, na.rm = TRUE),
    duration = first(duration),
    .groups = "drop"
  )


# Vowel space (all tokens)

ggplot(vowel_space, aes(x = F2, y = F1)) +
  geom_point(size = 1.5, alpha = 0.7) +
  scale_x_reverse() +
  scale_y_reverse() +
  labs(
    title = "Vowel space",
    x = "F2 (Hz)",
    y = "F1 (Hz)"
  ) +
  theme_bw()


# Vowel space (reduced y-axis)

ggplot(vowel_space, aes(x = F2, y = F1)) +
  geom_point(size = 1.5, alpha = 0.7) +
  
  scale_x_reverse() +
  
  scale_y_reverse(
    limits = c(1200, 100),
    breaks = seq(1200, 100, -100),
    minor_breaks = seq(1200, 100, -50)
  ) +
  
  labs(
    title = "Vowel space",
    x = "F2 (Hz)",
    y = "F1 (Hz)"
  ) +
  
  theme_bw()



# K-means clustering of possible /u/ and /o/

library(tidyverse)
library(cluster)

# Import Praat table

data <- read.delim(
  file = task02_file,
  header = TRUE,
  sep = "\t",
  fileEncoding = "UTF-16",
  na.strings = c(
    "",
    "NA",
    "--undefined--",
    "undefined"
  ),
  stringsAsFactors = FALSE,
  check.names = FALSE
)


# Inspect the imported table
names(data)
dim(data)
head(data)



# Make sure F1 and F2 are numeric

data <- data %>%
  mutate(
    f1 = as.numeric(f1),
    f2 = as.numeric(f2)
  )


# Select task 02

task02_data <- data %>%
  filter(task == "task02")


cat("Rows belonging to task02:", nrow(task02_data), "\n")
cat("Task02 recordings:", n_distinct(task02_data$file), "\n")



# Calculate one median F1/F2 value per recording

vowel_space <- task02_data %>%
  group_by(
    file,
    lg,
    spkr,
    sex,
    ethnicity,
    task,
    item
  ) %>%
  summarise(
    F1 = median(f1, na.rm = TRUE),
    F2 = median(f2, na.rm = TRUE),
    duration = first(duration),
    number_of_measurements = sum(
      is.finite(f1) & is.finite(f2)
    ),
    .groups = "drop"
  ) %>%
  mutate(
    # Replace NaN values produced when a file has no valid values
    F1 = ifelse(is.nan(F1), NA, F1),
    F2 = ifelse(is.nan(F2), NA, F2)
  ) %>%
  filter(
    is.finite(F1),
    is.finite(F2)
  )


cat(
  "Recordings with valid median F1 and F2:",
  nrow(vowel_space),
  "\n"
)



# Apply the predefined F1-F2 window

vowel_window <- vowel_space %>%
  filter(
    between(F1, 200, 700),
    between(F2, 500, 1400)
  )


cat(
  "Recordings before window filtering:",
  nrow(vowel_space),
  "\n"
)

cat(
  "Recordings inside the F1-F2 window:",
  nrow(vowel_window),
  "\n"
)

cat(
  "Recordings excluded by the window:",
  nrow(vowel_space) - nrow(vowel_window),
  "\n"
)


# Stop with an informative message if too little data remains

if (nrow(vowel_window) < 3) {
  stop(
    "Fewer than three valid recordings remain inside the specified F1-F2 window."
  )
}



# Standardize F1 and F2 for k-means

formants_scaled <- vowel_window %>%
  select(F1, F2) %>%
  scale()



# Run k-means with two clusters


set.seed(123)

kmeans_result <- kmeans(
  x = formants_scaled,
  centers = 2,
  nstart = 50
)

vowel_window$cluster_number <- kmeans_result$cluster



# Label the two clusters with "u-like" and "o-like"

cluster_summary <- vowel_window %>%
  group_by(cluster_number) %>%
  summarise(
    n = n(),
    median_F1 = median(F1),
    median_F2 = median(F2),
    mean_F1 = mean(F1),
    mean_F2 = mean(F2),
    .groups = "drop"
  ) %>%
  arrange(median_F1) %>%
  mutate(
    cluster_label = c("u-like", "o-like")
  )


print(cluster_summary)


vowel_window <- vowel_window %>%
  left_join(
    cluster_summary %>%
      select(cluster_number, cluster_label),
    by = "cluster_number"
  )


# Set the label order explicitly

vowel_window$cluster_label <- factor(
  vowel_window$cluster_label,
  levels = c("u-like", "o-like")
)



# Calculate the one separation measure

# Average silhouette width:

silhouette_result <- silhouette(
  vowel_window$cluster_number,
  dist(formants_scaled)
)

average_silhouette <- mean(
  silhouette_result[, "sil_width"]
)


cat(
  "\nAverage silhouette width:",
  round(average_silhouette, 3),
  "\n"
)


# Add each token's silhouette value to the output data

vowel_window$silhouette_width <-
  silhouette_result[, "sil_width"]



# Calculate cluster centers in original Hz

cluster_centres <- vowel_window %>%
  group_by(cluster_label) %>%
  summarise(
    centre_F1 = mean(F1),
    centre_F2 = mean(F2),
    n = n(),
    .groups = "drop"
  )


print(cluster_centres)



# Create the vowel-space plot

vowel_plot <- ggplot(
  vowel_window,
  aes(
    x = F2,
    y = F1,
    colour = cluster_label
  )
) +
  geom_point(
    size = 2,
    alpha = 0.75
  ) +
  stat_ellipse(
    aes(group = cluster_label),
    type = "norm",
    level = 0.68,
    linewidth = 0.8,
    show.legend = FALSE
  ) +
  geom_point(
    data = cluster_centres,
    aes(
      x = centre_F2,
      y = centre_F1
    ),
    inherit.aes = FALSE,
    shape = 4,
    size = 5,
    stroke = 1.5
  ) +
  scale_x_reverse(
    limits = c(1400, 500)
  ) +
  scale_y_reverse(
    limits = c(700, 200)
  ) +
  labs(
    title = "K-means clustering of possible /u/ and /o/ tokens",
    subtitle = paste0(
      "Average silhouette width = ",
      round(average_silhouette, 3)
    ),
    x = "F2 (Hz)",
    y = "F1 (Hz)",
    colour = "Acoustic cluster"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )


print(vowel_plot)


# Save the results

write.csv(
  vowel_window,
  file = "task02_kmeans_classified_tokens.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

write.csv(
  cluster_summary,
  file = "task02_kmeans_cluster_summary.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

write.csv(
  cluster_centres,
  file = "task02_kmeans_cluster_centres.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

ggsave(
  filename = "task02_kmeans_vowel_space.png",
  plot = vowel_plot,
  width = 8,
  height = 6,
  dpi = 300
)

getwd()
print(cluster_summary)
