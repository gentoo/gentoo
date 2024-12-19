#!/bin/bash

run_rc_files() {
	local prefix="${1}"
	local prev_opt=$(shopt -p nullglob)
	shopt -s nullglob
	for file in /etc/runit/rc/"${prefix}".*.sh; do
		if [[ ! -s "${f}" ]] || [[ ! -s "${f}" ]] ; then
			continue
		fi
		source "${file}"
	done
	${prev_opt}
}
