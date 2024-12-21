#!/bin/bash

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
