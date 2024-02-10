# genkernel (8) completion
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Written by Aron Griffis <agriffis@gentoo.org>

_genkernel()
{
    declare cur prev genkernel_help actions params
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    # extract initial list of params/actions from genkernel --help
    genkernel_help=$(command genkernel --help 2>/dev/null)
    actions=( $(<<<"$genkernel_help" sed -n \
	'/^Available Actions:/,/^$/s/^[[:space:]]\+\([^[:space:]]\+\).*/\1/p') )
    params=( $(<<<"$genkernel_help" egrep -oe '--[^[:space:]]{2,}') )

    # attempt to complete the current parameter based on the list
    COMPREPLY=($(compgen -W "${params[*]/=*/=} ${actions[*]}" -- "$cur"))

    # if we don't have a rhs to complete
    if [[ ${#COMPREPLY[@]} -gt 1 ]]; then
	return
    elif [[ ${#COMPREPLY[@]} -eq 0 && $cur != --*=* ]]; then
	return
    elif [[ ${#COMPREPLY[@]} -eq 1 && $COMPREPLY != --*= ]]; then
	# using nospace completion, add an explicit space
	COMPREPLY="${COMPREPLY} "
	return
    fi

    # we have a unique lhs and need to complete the rhs
    declare args lhs rhs
    if [[ ${#COMPREPLY[@]} -eq 1 ]]; then
	lhs=$COMPREPLY
    else
	lhs=${cur%%=*}=
	rhs=${cur#*=}
    fi

    # genkernel's help gives clues as to what belongs on the rhs.
    # extract the clue for the current parameter
    args=" ${params[*]} "
    args="${args##* $lhs}"
    args="${args%% *}"

    # generate a list of completions for the argument; this replaces args with
    # an array of results
    args=( $(case $args in
	('<0-5>') compgen -W "$(echo {1..5})" -- "$rhs" ;;
	('<outfile>'|'<file>') compgen -A file -o plusdirs -- "$rhs" ;;
	('<archive>') compgen -G '*.tar.xz' -G '*.tbz2' -G '*.tar.bz2' -o plusdirs -- "$rhs" ;;
	('<dir>'|'<path>') compgen -A directory -S / -- "$rhs" ;;

	(*) compgen -o bashdefault -- "$rhs" ;; # punt
    esac) )

    # we're using nospace completion to prevent spaces after paths that aren't
    # "done" yet.  So do some hacking to the args to add spaces after
    # non-directories.
    declare slash=/
    args=( "${args[@]/%/ }" )			# add space to all
    args=( "${args[@]/%$slash /$slash}" )	# remove space from dirs

    # recreate COMPREPLY
    if [[ $cur == "$lhs"* ]]; then
	COMPREPLY=( "${args[@]}" )
    elif [[ ${#args[@]} -gt 0 ]]; then
	COMPREPLY=( "${args[@]/#/$lhs}" )
    fi
}

complete -o nospace -F _genkernel genkernel
