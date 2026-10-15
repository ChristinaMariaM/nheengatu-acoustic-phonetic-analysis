########################################################################
# Extract /n/ durations from all V-n-d sequences
#
# Expected labels on tier 1:
# a | n | d
# e | n | d
# i | n | d
# u | n | d
########################################################################

form Extract n durations
    sentence textgrid_folder /path/to/task04_textgrids
    integer tier_number 1
    sentence output_file /path/to/n_durations.tsv
endform


# Start a new output file

deleteFile(output_file$)

appendFileLine(output_file$,
... "file", tab$,
... "token_in_file", tab$,
... "interval_number", tab$,
... "item", tab$,
... "vowel", tab$,
... "n_start_s", tab$,
... "n_end_s", tab$,
... "n_duration_s", tab$,
... "n_duration_ms")


# Obtain all TextGrid filenames

file_names$# = fileNames$#(textgrid_folder$ + "/*.TextGrid")
number_of_files = size(file_names$#)

if number_of_files = 0
    exitScript:
    ... "No TextGrid files were found in:" + newline$
    ... + textgrid_folder$
endif


total_tokens = 0
files_without_targets = 0
invalid_n_intervals = 0


# Loop through all TextGrid files in the input directory

for file_number from 1 to number_of_files

    file_name$ = file_names$#[file_number]
    full_path$ = textgrid_folder$ + "/" + file_name$

    Read from file: full_path$
    textgrid = selected("TextGrid")

    number_of_tiers = Get number of tiers

    if tier_number > number_of_tiers
        removeObject: textgrid
        exitScript:
        ... "Tier ", tier_number,
        ... " does not exist in ", file_name$
    endif

    number_of_intervals = Get number of intervals: tier_number
    token_in_file = 0

    # Examine each interval for an /n/ preceded by a vowel
 and followed by /d/
    for interval_number from 1 to number_of_intervals

        selectObject: textgrid
        current_label$ =
        ... Get label of interval: tier_number, interval_number

        if current_label$ = "n"

            valid_sequence = 0
            vowel$ = ""
            item$ = ""

            if interval_number > 1 and
            ... interval_number < number_of_intervals

                previous_label$ =
                ... Get label of interval:
                ... tier_number, interval_number - 1

                following_label$ =
                ... Get label of interval:
                ... tier_number, interval_number + 1

	        # Identify valid V-n-d sequences and their vowel categories
                if following_label$ = "d"

                    if previous_label$ = "a"
                        vowel$ = "a"
                        item$ = "and"
                        valid_sequence = 1

                    elsif previous_label$ = "e"
                        vowel$ = "e"
                        item$ = "end"
                        valid_sequence = 1

                    elsif previous_label$ = "i"
                        vowel$ = "i"
                        item$ = "ind"
                        valid_sequence = 1

                    elsif previous_label$ = "u"
                        vowel$ = "u"
                        item$ = "und"
                        valid_sequence = 1
                    endif

                endif
            endif

	    # For each valid sequence, calculate /n/ duration

	    # and append the measurements to the output file
            if valid_sequence = 1

                n_start =
                ... Get starting point:
                ... tier_number, interval_number

                n_end =
                ... Get end point:
                ... tier_number, interval_number

                n_duration_s = n_end - n_start
                n_duration_ms = n_duration_s * 1000

                token_in_file = token_in_file + 1
                total_tokens = total_tokens + 1

                appendFileLine(output_file$,
                ... file_name$, tab$,
                ... token_in_file, tab$,
                ... interval_number, tab$,
                ... item$, tab$,
                ... vowel$, tab$,
                ... fixed$(n_start, 6), tab$,
                ... fixed$(n_end, 6), tab$,
                ... fixed$(n_duration_s, 6), tab$,
                ... fixed$(n_duration_ms, 3))

            else
                invalid_n_intervals =
                ... invalid_n_intervals + 1
            endif

        endif

    endfor


    if token_in_file = 0
        files_without_targets =
        ... files_without_targets + 1
    endif

    removeObject: textgrid

endfor


# Summary

writeInfoLine: "Extraction completed."
appendInfoLine: "TextGrids processed: ", number_of_files
appendInfoLine: "Valid V-n-d tokens: ", total_tokens
appendInfoLine:
... "Files without valid targets: ", files_without_targets
appendInfoLine:
... "Other n intervals ignored: ", invalid_n_intervals
appendInfoLine: "Output file: ", output_file$