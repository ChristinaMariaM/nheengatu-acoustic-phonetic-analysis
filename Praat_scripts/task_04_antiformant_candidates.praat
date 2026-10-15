########################################################################
# Batch estimate antiformant candidates
#
# This script searches for the lowest spectral energy within the
# 540-1720 Hz frequency window for the middle 50% of each labeled
# vowel interval.
#
# The 540-1720 Hz range corresponds to the average F1+100 / F2-100
# window calculated from a sample of nasalized Nheengatu vowels.
#
# The script does not identify confirmed antiformants. Instead, it
# extracts exploratory "antiformant candidates": the frequency at which
# the lowest spectral energy occurs within the predefined window.
#
# Output:
#   file
#   label
#   start and end of analyzed interval
#   search range
#   minFreq_Hz = frequency of lowest spectral energy
#   minEnergy = raw minimum energy
#   minEnergy_dB = minimum energy converted to dB-like scale
#
# .wav and TextGrid files must be in the same folder and have matching
# filenames, e.g. file01.wav and file01.TextGrid.
########################################################################

form Batch estimate antiformant candidates
    sentence Data_folder /path/to/files/
    positive Tier 1
    sentence Output_file /path/to/antiformant_candidates.csv
endform

if right$(data_folder$, 1) <> "/"
    data_folder$ = data_folder$ + "/"
endif

# Search window based on average nasal F1+100 and F2-100 values
fmin = 540
fmax = 1720
range$ = "nasal_F1F2_window"

# Search settings
step = 10
bandwidth = 80

# Write semicolon-separated CSV header for Excel
if fileReadable(output_file$)
    deleteFile: output_file$
endif
appendFileLine: output_file$, "file;label;start;end;range;minFreq_Hz;minEnergy;minEnergy_dB"

# Get all .wav files from the folder
Create Strings as file list: "wav_files", data_folder$ + "*.wav"
nfiles = Get number of strings
writeInfoLine: "Number of WAV files found: ", nfiles

if nfiles = 0
    removeObject: "Strings wav_files"
    exitScript: "No .wav files found. Check Data_folder and make sure it ends with /"
endif

# Loop through all .wav files
for ifile from 1 to nfiles

    selectObject: "Strings wav_files"
    wavname$ = Get string: ifile

    # Build paths for .wav and matching TextGrid
    wavpath$ = data_folder$ + wavname$
    tgname$ = replace$(wavname$, ".wav", ".TextGrid", 0)
    tgpath$ = data_folder$ + tgname$

    # Read .wav file
    Read from file: wavpath$
    sound = selected("Sound")
    soundname$ = selected$("Sound")

    # Read corresponding TextGrid
    Read from file: tgpath$
    tg = selected("TextGrid")

    # Get number of intervals in selected tier
    selectObject: tg
    nint = Get number of intervals: tier

    # Loop through intervals
    # IMPORTANT:
    # found = 0 ensures that only the first non-empty vowel label is measured.
    # This gives one output row per vowel file.
    found = 0

    for i from 1 to nint

        selectObject: tg
        label$ = Get label of interval: tier, i

        # Skip empty intervals
        if label$ <> "" and found = 0

            found = 1

            # Get interval boundaries
            start = Get start time of interval: tier, i
            end = Get end time of interval: tier, i

            # Use only middle 50% of the vowel to avoid transitions
            dur = end - start
            midStart = start + dur * 0.25
            midEnd = end - dur * 0.25

            # Extract middle 50% of the interval
            selectObject: sound
            part = Extract part: midStart, midEnd, "Hanning", 1, "yes"

            # Convert extracted part to Spectrum
            selectObject: part
            To Spectrum: "yes"
            spectrum = selected("Spectrum")

            # Initialize minimum search
            minEnergy = 1e99
            minFreq = undefined

            # Search through the 540-1720 Hz window
            f = fmin
            while f <= fmax

                # Measure energy in an 80-Hz band around current frequency
                low = f - bandwidth / 2
                high = f + bandwidth / 2

                selectObject: spectrum
                energy = Get band energy: low, high

                # Store the frequency with the lowest energy
                if energy < minEnergy
                    minEnergy = energy
                    minFreq = f
                endif

                f = f + step
            endwhile

            # Convert minimum energy to dB-like scale
            if minEnergy > 0
                minEnergy_dB = 10 * log10(minEnergy)
            else
                minEnergy_dB = undefined
            endif

            # Write result to CSV
            appendFileLine: output_file$, soundname$, ";", label$, ";", fixed$(midStart, 4), ";", fixed$(midEnd, 4), ";", range$, ";", fixed$(minFreq, 1), ";", fixed$(minEnergy, 8), ";", fixed$(minEnergy_dB, 2)

            # Remove temporary objects
            removeObject: spectrum
            removeObject: part

        endif
    endfor

    if found = 0
        appendInfoLine: "No non-empty label found in: ", wavname$
    endif

    # Remove current file objects
    removeObject: tg
    removeObject: sound

endfor

# Remove .wav file list
removeObject: "Strings wav_files"

writeInfoLine: "Done. Results written to: ", output_file$
