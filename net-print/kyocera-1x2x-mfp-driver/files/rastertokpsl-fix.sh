#!/bin/bash
# This file is a slightly modified version of 'rastertokpsl_wrapper' script
# by Maxim Norin. See https://github.com/mnorin/kyocera-ppd-installer for
# the original version.
# Distributed under the terms of the GNU General Public License v2.
jobname="$(echo "$3" | grep -Eo "[[:alnum:]]" | tr -d "\n" | tail -c 20)"

#there may be options that cause the application to crash
function filterOptions {
        # Split options by IFS (default: by whitespaces).
        local optionsArray=($1)

        local resultArray
        local option
        for option in "${optionsArray[@]}"; do
            case "$option" in
                Resolution*|PageSize*|fit-to-page*)
                    resultArray+=("$option")
                    ;;
                *)
                    ;; # Ignore any unsupported option.
            esac
        done

        echo -n "${resultArray[*]}"
    }

/usr/libexec/cups/filter/rastertokpsl "$1" "$2" "$jobname" "$4" "$(filterOptions "$5")"
