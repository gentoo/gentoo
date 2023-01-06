#!/usr/bin/env bash
# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
cd "${SCRIPT_DIR}"

source tests-common.sh || exit

inherit gradle

# TODO: hack because tests-common don't implement ver_cut
EAPI=6 inherit eapi7-ver

test_set_EGRADLE() {
	local expected_EGRADLE="${1}"

	shift

	local tmpdir
	tmpdir=$(mktemp -d || die)
	for pseudo_gradle in "${@}"; do
		local pseudo_gradle_path="${tmpdir}/${pseudo_gradle}"
		touch "${pseudo_gradle_path}"
		chmod 755 "${pseudo_gradle_path}"
	done

	EGRADLE_SEARCH_PATH="${tmpdir}"

	local test_desc=(
		test_set_EGRADLE
	)
	[[ -v EGRADLE_MIN ]] &&	test_desc+=( "EGRADLE_MIN=${EGRADLE_MIN}" )
	[[ -v EGRADLE_MAX_EXCLUSIVE ]] && test_desc+=( "EGRADLE_MAX_EXCLUSIVE=${EGRADLE_MAX_EXCLUSIVE}" )
	test_desc+=( $@ )

	tbegin "${test_desc[@]}"
	gradle-set_EGRADLE

	local saved_EGRADLE="${EGRADLE}"
	unset EGRADLE

	rm -rf "${tmpdir}"

	# The saved_EGRADLE variable will contain something like
	# /tmp/tmp.vTN7A1l6C7/gradle-2.0, but we only want to compare the
	# name of the binary.
	saved_EGRADLE=$(basename ${saved_EGRADLE})

	[[ "${saved_EGRADLE}" == "${expected_EGRADLE}" ]]
	tend $?

	if (( $? > 0 )); then
		>&2 echo -e "\t expected=${expected_EGRADLE} actual=${saved_EGRADLE}"
	fi
}

test_set_EGRADLE gradle-2.0 gradle-1.0 gradle-2.0
EGRADLE_MIN=2.0 test_set_EGRADLE gradle-2.2.3 gradle-1.0 gradle-2.0 gradle-2.2.3
EGRADLE_MAX_EXCLUSIVE=2.2 test_set_EGRADLE gradle-2.0 gradle-1.0 gradle-2.0 gradle-2.2.3

texit
