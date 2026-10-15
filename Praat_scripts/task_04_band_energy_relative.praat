########################################################################
# Batch measurement of relative spectral band energy in nasalized vowels
#
# This script measures spectral energy between 540 and 1720 Hz for the
# middle 50% of each labeled vowel interval.
#
# It then divides this value by the total spectral energy of the same
# vowel segment. This gives a relative energy measure that is less
# affected by recording volume, microphone gain, or speaker loudness.
#
# The frequency window 540-1720 Hz corresponds to the average F1+100 /
# F2-100 range calculated from nasalized Nheengatu vowels.
#
# Lower relativeBandEnergy_dB values indicate proportionally weaker
# spectral energy in the F1-F2 region, i.e. stronger visual "whitening".
#
# .wav and TextGrid files must be in the same folder and have matching
# filenames, e.g. file01.wav and file01.TextGrid.
########################################################################

form Batch measure relative nasal-window energy
    sentence Data_folder /path/to/files/
    positive Tier 1
    sentence Output_file /path/to/relative_nasal_window_energy.csv
endform


if right$(data_folder$, 1) <> "/"
    data_folder$ = data_folder$ + "/"
endif

# Nasal weakening window
fmin = 540
fmax = 1720

# Reference range: total spectrum used for comparison
totalMin = 0
totalMax = 5000

# Write semicolon-separated CSV header for Excel
if fileReadable(output_file$)
    deleteFile: output_file$
endif
appendFileLine: output_file$, "file;label;start;end;window_Hz;windowEnergy;totalEnergy;relativeBandEnergy;relativeBandEnergy_dB"

# Get all .wav files from folder
Create Strings as file list: "wav_files", data_folder$ + "*.wav"
nfiles = Get number of strings
writeInfoLine: "Number of WAV files found: ", nfiles

if nfiles = 0
    removeObject: "Strings wav_files"
    exitScript: "No .wav files found. Check Data_folder and make sure it ends with /"
endif

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

    selectObject: tg
    nint = Get number of intervals: tier

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

            # Get original interval boundaries
            start = Get start time of interval: tier, i
            end = Get end time of interval: tier, i

            # Use only middle 50% of vowel to avoid consonantal transitions
            dur = end - start
            midStart = start + dur * 0.25
            midEnd = end - dur * 0.25

            # Extract middle 50%
            selectObject: sound
            part = Extract part: midStart, midEnd, "Hanning", 1, "yes"

            # Convert extracted vowel part to Spectrum
            selectObject: part
            To Spectrum: "yes"
            spectrum = selected("Spectrum")

            # Measure energy in nasal weakening window
            selectObject: spectrum
            windowEnergy = Get band energy: fmin, fmax

            # Measure total energy of the same vowel segment
            totalEnergy = Get band energy: totalMin, totalMax

            # Calculate relative energy
            if windowEnergy > 0 and totalEnergy > 0
                relativeBandEnergy = windowEnergy / totalEnergy
                relativeBandEnergy_dB = 10 * log10(relativeBandEnergy)
            else
                relativeBandEnergy = undefined
                relativeBandEnergy_dB = undefined
            endif

            # Write result to CSV
            appendFileLine: output_file$, soundname$, ";", label$, ";", fixed$(midStart, 4), ";", fixed$(midEnd, 4), ";", fixed$(fmin, 0), "-", fixed$(fmax, 0), ";", fixed$(windowEnergy, 2), ";", fixed$(totalEnergy, 2), ";", fixed$(relativeBandEnergy, 6), ";", fixed$(relativeBandEnergy_dB, 2)

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
