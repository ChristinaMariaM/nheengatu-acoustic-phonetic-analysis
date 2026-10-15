################################################################################
# Task 02 vowel space: extract F1/F2 for ALL intervals in Tier 1
# Output is written as a TAB-separated .tsv file
################################################################################

# Define input directory and formant analysis parameters.

# Replace the folder placeholder with the local data directory.

# Default settings: Tier 1, five formants, 5500-Hz ceiling.
form Extract F1 F2 for task02
    sentence Folder PATH_TO_TASK02_DATA_DIRECTORY
    positive Tier_number 1
    positive Max_formant 5500
    positive Number_of_formants 5
endform

# Remove final slash if present
if right$(folder$, 1) = "/" or right$(folder$, 1) = "\"
    folder$ = left$(folder$, length(folder$) - 1)
endif

# Define the output file in the input directory
output_file$ = folder$ + "/task02_formants_all_intervals.tsv"

# Create a list of all .wav files in the directory
Create Strings as file list: "wavFiles", folder$ + "/*.wav"

n = Get number of strings

# Stop execution if no .wav files are found
if n = 0
    exitScript: "No .wav files found in folder: ", folder$
endif

# Delete any previous output file with the same name

# and write the column headers
filedelete 'output_file$'

fileappend 'output_file$' "file"'tab$'"interval_number"'tab$'"label"'tab$'"start"'tab$'"end"'tab$'"duration"'tab$'"midpoint"'tab$'"F1"'tab$'"F2"'newline$'

# Initialize the measurement counter
count = 0

# Process each .wav file and locate its corresponding TextGrid
for i from 1 to n

    selectObject: "Strings wavFiles"
    wav$ = Get string: i
    base$ = wav$ - ".wav"

    tg_path$ = folder$ + "/" + base$ + ".TextGrid"

    # Continue only if a matching TextGrid exists
    if fileReadable(tg_path$)

        # Load the sound recording and annotation file
        Read from file: folder$ + "/" + wav$
        sound = selected("Sound")

        Read from file: tg_path$
        tg = selected("TextGrid")

          # Calculate formant tracks using Praat's Burg method.

          # Formant ceiling and number of formants are taken

          # from the input form.

          # Window length: 0.025 s; pre-emphasis: 50 Hz.
        selectObject: sound
        To Formant (burg): 0, number_of_formants, max_formant, 0.025, 50
        formant = selected("Formant")

        # Determine the number of intervals in the selected tier
        selectObject: tg
        intervals = Get number of intervals: tier_number

        # Process all annotated intervals, retaining their

        # original labels and temporal boundaries
        for j from 1 to intervals

            selectObject: tg
            label$ = Get label of interval: tier_number, j
            start = Get start time of interval: tier_number, j
            end = Get end time of interval: tier_number, j
            duration = end - start
            midpoint = (start + end) / 2

            # Extract measurements only from intervals

            # with a positive duration
            if duration > 0

                # Obtain F1 and F2 at the temporal midpoint

                # using linear interpolation
                selectObject: formant
                f1 = Get value at time: 1, midpoint, "Hertz", "Linear"
                f2 = Get value at time: 2, midpoint, "Hertz", "Linear"

                # Append the measurements and interval metadata

                # to the tab-separated output file
                fileappend 'output_file$' 'base$''tab$''j''tab$''label$''tab$''start''tab$''end''tab$''duration''tab$''midpoint''tab$''f1''tab$''f2''newline$'

                count = count + 1

            endif

        endfor

        # Remove temporary objects
        selectObject: formant
        Remove
        selectObject: tg
        Remove
        selectObject: sound
        Remove

    else

        # Report .wav files without matching TextGrid annotations
        appendInfoLine: "Missing TextGrid for: ", wav$
    endif

endfor

# Remove the temporary list of .wav filenames
selectObject: "Strings wavFiles"
Remove

# Report the total number of measurements and

# the location of the resulting TSV file
appendInfoLine: "Done."
appendInfoLine: "Measurements written: ", count
appendInfoLine: "TSV file should be here:"
appendInfoLine: output_file$