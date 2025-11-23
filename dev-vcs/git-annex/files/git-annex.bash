_git_annex()
{
    local cmdline
    local IFS=$'
'
    CMDLINE=(--bash-completion-index $COMP_CWORD)

    if [[ "${COMP_WORDS[@]:0:2}" == "git annex" ]]; then
        unset COMP_WORDS[0]
        COMP_WORDS[1]="git-annex"
    fi
    for arg in ${COMP_WORDS[@]}; do
        CMDLINE=(${CMDLINE[@]} --bash-completion-word $arg)
    done

    COMPREPLY=( $(/usr/bin/git-annex "${CMDLINE[@]}") )
}

complete -o filenames -F _git_annex git-annex
