########################################################################
# Batch measure F1, F2 and vowel duration at midpoint
#
# .wav and TextGrid files must be in the same folder.
# Filenames must match, e.g. file01.wav / file01.TextGrid.
#
# The script measures:
#   - vowel duration
#   - midpoint time
#   - F1 at midpoint
#   - F2 at midpoint
########################################################################

form Batch measure vowel formants and duration
    sentence Data_folder /path/to/files/
    positive Tier 1
    positive Max_formant_Hz 5500
    positive Number_of_formants 5
    sentence Output_file /path/to/vowel_formants.csv
endform

if fileReadable(output_file$)
    deleteFile: output_file$
endif

appendFileLine: output_file$, "file;label;start;end;duration;midpoint;F1_Hz;F2_Hz"

Create Strings as file list: "wav_files", data_folder$ + "*.wav"
nfiles = Get number of strings

for ifile from 1 to nfiles

    selectObject: "Strings wav_files"
    wavname$ = Get string: ifile

    wavpath$ = data_folder$ + wavname$
    tgname$ = replace$(wavname$, ".wav", ".TextGrid", 0)
    tgpath$ = data_folder$ + tgname$

    Read from file: wavpath$
    sound = selected("Sound")
    soundname$ = selected$("Sound")

    Read from file: tgpath$
    tg = selected("TextGrid")

    # Create Formant object from the whole sound
    selectObject: sound
    To Formant (burg): 0, number_of_formants, max_formant_Hz, 0.025, 50
    formant = selected("Formant")

    selectObject: tg
    nint = Get number of intervals: tier

    for i from 1 to nint

        selectObject: tg
        label$ = Get label of interval: tier, i

        if label$ <> ""

            start = Get start time of interval: tier, i
            end = Get end time of interval: tier, i
            duration = end - start
            midpoint = start + duration / 2

            selectObject: formant
            f1 = Get value at time: 1, midpoint, "Hertz", "Linear"
            f2 = Get value at time: 2, midpoint, "Hertz", "Linear"

            appendFileLine: output_file$, soundname$, ";", label$, ";", fixed$(start, 4), ";", fixed$(end, 4), ";", fixed$(duration, 4), ";", fixed$(midpoint, 4), ";", fixed$(f1, 2), ";", fixed$(f2, 2)

        endif
    endfor

    removeObject: formant
    removeObject: tg
    removeObject: sound

endfor

removeObject: "Strings wav_files"