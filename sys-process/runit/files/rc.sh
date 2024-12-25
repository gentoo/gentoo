#!/bin/bash

# run script(s) at /etc/runit/rc/, suffix must be .sh, prefix
# must be [1|3] which denote stage 1 or 3.
run_rc_stage() {
	local prefix="${1}"
	local prev_opt=$(shopt -p nullglob)
	shopt -s nullglob
	for file in /etc/runit/rc/"${prefix}".*.sh; do
		if [[ ! -x "${file}" ]] || [[ ! -s "${file}" ]] ; then
			continue
		fi
		. "${file}"
	done
	${prev_opt}
}
