
form Extract Task 04 target vowel spectra
    sentence input_folder /path/to/task04_recordings
    sentence output_file /path/to/task04_spectra.tsv
    positive tier_number 1
    positive window_duration_ms 40
    positive minimum_frequency_hz 300
    positive maximum_frequency_hz 3000
endform


# Settings

window_duration_s = window_duration_ms / 1000
half_window_s = window_duration_s / 2


# Prepare output file

deleteFile: output_file$

writeFileLine: output_file$, "source_file", tab$, "token", tab$, "vowel", tab$, "vowel_base", tab$, "dataset", tab$, "interval_number", tab$, "vowel_start_s", tab$, "vowel_end_s", tab$, "vowel_duration_ms", tab$, "window_start_s", tab$, "window_end_s", tab$, "frequency_hz", tab$, "amplitude_db_hz"


# Find all .wav files

wav_files$# = fileNames$#: input_folder$ + "/*.wav"
number_of_files = size (wav_files$#)

if number_of_files = 0
    exitScript: "No WAV files were found in ", input_folder$
endif


# Initial report

clearinfo
appendInfoLine: "Input folder: ", input_folder$
appendInfoLine: "WAV files found: ", number_of_files
appendInfoLine: "Output file: ", output_file$
appendInfoLine: ""

spectra_exported = 0
files_skipped = 0
rows_exported = 0


# Process each file

for file_index from 1 to number_of_files

    wav_file$ = wav_files$#[file_index]
    base_name$ = left$ (wav_file$, length (wav_file$) - 4)

    wav_path$ = input_folder$ + "/" + wav_file$
    textgrid_path$ = input_folder$ + "/" + base_name$ + ".TextGrid"

    appendInfoLine: "Processing ", file_index, "/", number_of_files, ": ", wav_file$


    # Check for matching TextGrid

    if not fileReadable (textgrid_path$)

        appendInfoLine: "   SKIPPED: matching TextGrid not found."
        files_skipped = files_skipped + 1

    else

        # Read sound and TextGrid

        Read from file: wav_path$
        sound = selected ("Sound")

        Read from file: textgrid_path$
        textgrid = selected ("TextGrid")


        # Check tier

        selectObject: textgrid
        number_of_tiers = Get number of tiers

        if tier_number > number_of_tiers

            appendInfoLine: "   SKIPPED: tier ", tier_number, " does not exist."
            files_skipped = files_skipped + 1

            removeObject: sound, textgrid

        else

            selectObject: textgrid
            number_of_intervals = Get number of intervals: tier_number

            number_of_targets = 0
            target_interval = 0
            target_label$ = ""
            vowel_base$ = ""


            # Find the target vowel

for interval_number from 1 to number_of_intervals

    selectObject: textgrid
    label$ = Get label of interval: tier_number, interval_number

    is_target = 0
    current_vowel_base$ = ""

    if label$ = "a"
        is_target = 1
        current_vowel_base$ = "a"

    elsif label$ = "e"
        is_target = 1
        current_vowel_base$ = "e"

    elsif label$ = "i"
        is_target = 1
        current_vowel_base$ = "i"

    elsif label$ = "u"
        is_target = 1
        current_vowel_base$ = "u"
    endif

    if is_target = 1
        number_of_targets = number_of_targets + 1
        target_interval = interval_number
        target_label$ = label$
        vowel_base$ = current_vowel_base$
    endif

endfor


            # Check target count

            if number_of_targets = 0

                appendInfoLine: "   SKIPPED: no target vowel found."
                files_skipped = files_skipped + 1

                removeObject: sound, textgrid

            elsif number_of_targets > 1

                appendInfoLine: "   SKIPPED: ", number_of_targets, " target vowels found; exactly one was expected."
                files_skipped = files_skipped + 1

                removeObject: sound, textgrid

            else

                # Get vowel boundaries

                selectObject: textgrid

                vowel_start = Get starting point: tier_number, target_interval
                vowel_end = Get end point: tier_number, target_interval

                vowel_duration = vowel_end - vowel_start
                midpoint = (vowel_start + vowel_end) / 2

                window_start = midpoint - half_window_s
                window_end = midpoint + half_window_s


                # Check window length

                if window_start < vowel_start or window_end > vowel_end

                    appendInfoLine: "   SKIPPED: vowel ", target_label$, " is only ", fixed$ (vowel_duration * 1000, 1), " ms long."
                    files_skipped = files_skipped + 1

                    removeObject: sound, textgrid

                else

                    # Create token name

                    token_name$ = base_name$ + "_target"


                    # Extract midpoint window

                    selectObject: sound
                    Extract part: window_start, window_end, "Hanning", 1.0, "no"

                    extracted_sound = selected ("Sound")
                    Rename: token_name$


                    # Create spectrum and LTAs

                    selectObject: extracted_sound
                    To Spectrum: "yes"

                    spectrum = selected ("Spectrum")

                    selectObject: spectrum
                    To Ltas (1-to-1)

                    ltas = selected ("Ltas")


                    # Build one text block for this token

                    selectObject: ltas
                    number_of_bins = Get number of bins

                    token_output$ = ""
                    token_rows = 0

                    for bin_number from 1 to number_of_bins

                        selectObject: ltas
                        frequency = Get frequency from bin number: bin_number

                        if frequency >= minimum_frequency_hz and frequency <= maximum_frequency_hz

                            amplitude_db = Get value in bin: bin_number

                            row$ = wav_file$ + tab$ + token_name$ + tab$ + target_label$ + tab$ + vowel_base$ + tab$ + "task04" + tab$ + string$ (target_interval) + tab$ + fixed$ (vowel_start, 6) + tab$ + fixed$ (vowel_end, 6) + tab$ + fixed$ (vowel_duration * 1000, 3) + tab$ + fixed$ (window_start, 6) + tab$ + fixed$ (window_end, 6) + tab$ + fixed$ (frequency, 6) + tab$ + fixed$ (amplitude_db, 6) + newline$

                            token_output$ = token_output$ + row$

                            token_rows = token_rows + 1
                            rows_exported = rows_exported + 1

                        endif

                    endfor


                    # Writw once per token

                    appendFile: output_file$, token_output$

                    spectra_exported = spectra_exported + 1

                    appendInfoLine: "   EXPORTED: ", token_name$, " | vowel = ", target_label$, " | bins = ", token_rows


                    # Remove all temporary objects

                    removeObject: sound, textgrid, extracted_sound, spectrum, ltas

                endif

            endif

        endif

    endif

endfor


# Final report

appendInfoLine: ""
appendInfoLine: "Finished."
appendInfoLine: "WAV files found: ", number_of_files
appendInfoLine: "Spectra exported: ", spectra_exported
appendInfoLine: "Files skipped: ", files_skipped
appendInfoLine: "Rows exported: ", rows_exported
appendInfoLine: "Output file: ", output_file$