# Not bash? Return
[ -n "${BASH_VERSION:-}" ] || return 0

# Make sure that PROMPT_COMMAND is an array, which is permitted as of bash 5.1.
case $(declare -p PROMPT_COMMAND 2>/dev/null) in
        'declare -a '*)
                # Nothing to do, already an array.
                :
                ;;
        '')
                PROMPT_COMMAND=()
                ;;
        *)
                PROMPT_COMMAND=( "${PROMPT_COMMAND}" )
                ;;
esac
