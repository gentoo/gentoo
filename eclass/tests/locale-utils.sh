#!/bin/bash
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

inherit locale-utils

if ! type -P localedef >/dev/null; then
	ewarn "localedef not found, skipping tests"
	texit
fi

IUSE="elibc_glibc"
BROOT=
mkdir -p "${T}" || die

# Print the charmap of a locale, or nothing if the locale is unavailable.
charmap() {
	local out
	out=$(LC_ALL=${1} locale charmap 2>&1) || return
	[[ ${out} == *$'\n'* ]] || echo "${out}"
}

test_locale() {
	local name=${1} exp=${2}
	local have
	tbegin "${name} -> ${exp:-unavailable}"
	have=$(charmap "${name}")
	[[ ${have} == "${exp}" ]]
	tend $? "charmap: ${have:-unavailable}"
}

tbegin "elocale_gen cs_CZ.UTF-8 en_US de_DE@euro ja_JP.eucjp"
LANG=sv_SE.utf8 elocale_gen cs_CZ.UTF-8 en_US de_DE@euro ja_JP.eucjp >/dev/null
tend $?

tbegin "LOCPATH is exported"
[[ $(declare -p LOCPATH 2>/dev/null) == "declare -x LOCPATH=\"${T}/locale\"" ]]
tend $?

test_locale cs_CZ.UTF-8 UTF-8
test_locale cs_CZ.utf8 UTF-8
test_locale en_US ISO-8859-1
test_locale de_DE@euro ISO-8859-15
test_locale ja_JP.EUC-JP EUC-JP
test_locale C.UTF-8 UTF-8
# taken from the environment
test_locale sv_SE.UTF-8 UTF-8
# never requested
test_locale fr_FR.UTF-8 ""

tbegin "elocale_gen accumulates"
elocale_gen en_US.ISO-8859-1 >/dev/null
tend $?
test_locale en_US.iso88591 ISO-8859-1
test_locale cs_CZ.UTF-8 UTF-8

tbegin "a local LOCPATH does not outlive the caller"
unset LOCPATH
scoped() {
	local -x LOCPATH
	elocale_gen cs_CZ.UTF-8 >/dev/null && [[ ${LOCPATH} == "${T}/locale" ]]
}
scoped && [[ ! -v LOCPATH ]]
tend $?

tbegin "--set exports the variable without a warning from bash"
set_scoped() {
	local -x LOCPATH LC_ALL
	elocale_gen --set LC_ALL cs_CZ.UTF-8 de_DE@euro >/dev/null &&
		[[ $(declare -p LC_ALL) == 'declare -x LC_ALL="cs_CZ.UTF-8"' ]] &&
		[[ $(locale charmap) == UTF-8 ]]
}
set_scoped 2> "${T}/stderr" && [[ ! -s ${T}/stderr && ! -v LC_ALL ]]
tend $?

tbegin "--set rejects other variables"
! (elocale_gen --set PATH cs_CZ.UTF-8) &>/dev/null
tend $?

tbegin "unknown locale fails"
! (elocale_gen xx_XX.UTF-8) &>/dev/null
tend $?

tbegin "codeset without letters or digits fails"
! (elocale_gen en_US.-) &>/dev/null
tend $?

# What sys-apps/musl-locales would list.
musl_locale() {
	[[ ${1} == -a ]] || return 1
	printf '%s\n' C C.UTF-8 cs_CZ.UTF-8 de_DE.UTF-8
}

tbegin "non-glibc returns 0 if the system has the locales"
(
	IUSE=
	locale() { musl_locale "$@"; }
	elocale_gen cs_CZ.utf8 de_DE.UTF-8 C.UTF-8 && [[ ! -v LOCPATH ]]
)
tend $?

tbegin "non-glibc returns 1 if a locale is missing"
(
	IUSE=
	locale() { musl_locale "$@"; }
	elocale_gen cs_CZ.UTF-8 fr_FR.UTF-8
	[[ $? -eq 1 ]]
)
tend $?

tbegin "non-glibc does not take cs_CZ.UTF-8 for cs_CZ"
(
	IUSE=
	locale() { musl_locale "$@"; }
	elocale_gen cs_CZ
	[[ $? -eq 1 ]]
)
tend $?

tbegin "non-glibc returns 1 without a locale command"
(
	IUSE=
	locale() { return 127; }
	elocale_gen C.UTF-8
	[[ $? -eq 1 ]]
)
tend $?

tbegin "non-glibc still exports the variable"
(
	IUSE=
	unset LC_ALL
	locale() { musl_locale "$@"; }
	# bash on glibc warns here. It does not with the libcs this is for.
	elocale_gen --set LC_ALL fr_FR.UTF-8 2>/dev/null
	[[ $? -eq 1 && $(declare -p LC_ALL) == 'declare -x LC_ALL="fr_FR.UTF-8"' ]]
)
tend $?

texit
