# Task 04 vowel extraction 
# Original extraction-script concept: Prof. Volker Dellwo.
# Study-specific adaptation reconstructed from the earlier specification.
# Tier 1: a/e/i/u followed immediately by n then d; tier 2 is ignored.
# The script extracts only the vowel interval, without zero-crossing adjustment.

rDir$ = "PATH_TO_INPUT_DIRECTORY/"
wDir$ = "PATH_TO_OUTPUT_DIRECTORY/"

fileNames$# = fileNames$#(rDir$ + "*.wav")

for iFile to size(fileNames$#)
    file$ = fileNames$#[iFile] - ".wav"
    sound = Read from file: rDir$ + file$ + ".wav"
    tg = Read from file: rDir$ + file$ + ".TextGrid"

    vowelTier = 1
    selectObject: tg
    nInt = Get number of intervals: vowelTier
    vowelNumber = 0

    for iInt to nInt - 2
        selectObject: tg
        label$ = Get label of interval: vowelTier, iInt
        nextLabel$ = Get label of interval: vowelTier, iInt + 1
        finalLabel$ = Get label of interval: vowelTier, iInt + 2

        if (label$ = "a" or label$ = "e" or label$ = "i" or label$ = "u") and nextLabel$ = "n" and finalLabel$ = "d"
            vowelNumber = vowelNumber + 1
            number$ = string$(vowelNumber)
            if length(number$) = 1
                number$ = "0" + number$
            endif

            start = Get start point: vowelTier, iInt
            end = Get end point: vowelTier, iInt
	   
	    # Extract TextGrid part and save to file:
            selectObject: tg
            partTg = Extract part: start, end, 0
            Save as text file: wDir$ + file$ + "_" + number$ + "_" + label$ + ".TextGrid"

	    # Extract Sound part and save to file:
            selectObject: sound
            partWav = Extract part: start, end, "Rectangular", 1, 0
            Save as WAV file: wDir$ + file$ + "_" + number$ + "_" + label$ + ".wav"

	    # Clean up:
            removeObject: partTg, partWav

        endif

    endfor

     # Clean up:
    removeObject: sound, tg

endfor
