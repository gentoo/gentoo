# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: locale-utils.eclass
# @MAINTAINER:
# Matt Turner <mattst88@gentoo.org>
# @AUTHOR:
# Matt Turner <mattst88@gentoo.org>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: Generate locales into a private directory
# @DESCRIPTION:
# Test suites frequently call setlocale(3) with specific locales and fail if
# they are not available. Which locales exist is system configuration
# (/etc/locale.gen), so an ebuild can neither depend on them nor expect
# them to be present. elocale_gen generates them instead.
#
# Example:
# @CODE
# inherit locale-utils
#
# src_test() {
# 	local -x LOCPATH
# 	if elocale_gen cs_CZ.UTF-8 de_DE@euro; then
# 		meson_src_test
# 	else
# 		meson_src_test --no-suite locale
# 	fi
# }
# @CODE
#
# If the locale also has to be selected, pass --set instead of assigning the
# variable:
# @CODE
# src_test() {
# 	local -x LOCPATH LC_ALL
# 	elocale_gen --set LC_ALL en_US.UTF-8
# 	cmake_src_test
# }
# @CODE

case ${EAPI} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_LOCALE_UTILS_ECLASS} ]]; then
_LOCALE_UTILS_ECLASS=1

# @ECLASS_VARIABLE: _LOCALE_UTILS_RE
# @INTERNAL
# @DESCRIPTION:
# Regular expression that splits a locale name into its parts:
# language[_territory][.codeset][@modifier]
_LOCALE_UTILS_RE='^([^.@]+)(\.([^@]+))?(@.+)?$'

# @FUNCTION: _locale-utils_installed
# @INTERNAL
# @USAGE: <locale>
# @DESCRIPTION:
# Check whether "locale -a" lists the locale, whichever way the codeset is
# spelled on either side.
_locale-utils_installed() {
	local want have codeset

	[[ ${1} =~ ${_LOCALE_UTILS_RE} ]] || return 1
	codeset=${BASH_REMATCH[3]//[^[:alnum:]]}
	want=${BASH_REMATCH[1]}${codeset:+.${codeset,,}}${BASH_REMATCH[4]}

	while read -r have; do
		[[ ${have} =~ ${_LOCALE_UTILS_RE} ]] || continue
		codeset=${BASH_REMATCH[3]//[^[:alnum:]]}
		have=${BASH_REMATCH[1]}${codeset:+.${codeset,,}}${BASH_REMATCH[4]}
		[[ ${have} == "${want}" ]] && return 0
	done < <(locale -a 2>/dev/null)

	return 1
}

# @FUNCTION: _locale-utils_gen
# @INTERNAL
# @USAGE: <log command> <directory> <locale>
# @DESCRIPTION:
# Compile a single locale into the directory, unless it is already there.
# Returns non-zero if glibc does not support the locale or if localedef fails,
# after reporting the reason using the log command, e.g. eerror or debug-print.
_locale-utils_gen() {
	local log=${1} dir=${2} name=${3}
	local re=${_LOCALE_UTILS_RE}

	if [[ ! ${name} =~ ${re} ]]; then
		${log} "${FUNCNAME}: ${name}: not a valid locale name"
		return 1
	fi
	local lang=${BASH_REMATCH[1]} modifier=${BASH_REMATCH[4]}
	local codeset=${BASH_REMATCH[3]//[^[:alnum:]]}
	codeset=${codeset,,}
	# A codeset without a single letter or digit, which would otherwise be
	# taken for no codeset at all.
	if [[ -n ${BASH_REMATCH[3]} && -z ${codeset} ]]; then
		${log} "${FUNCNAME}: ${name}: not a valid locale name"
		return 1
	fi

	# glibc looks a locale up both under the name it was asked for and
	# under that name with the codeset normalized, e.g. cs_CZ.UTF-8 and
	# cs_CZ.utf8. Using the normalized name makes every spelling work.
	local out=${dir}/${lang}${codeset:+.${codeset}}${modifier}

	[[ -d ${out} ]] && return 0

	local supported=${BROOT}/usr/share/i18n/SUPPORTED
	local entry charmap normalized found
	while read -r entry charmap; do
		if [[ ${entry} =~ ${re} && ${BASH_REMATCH[1]} == "${lang}" &&
			${BASH_REMATCH[4]} == "${modifier}" ]]
		then
			if [[ -n ${codeset} ]]; then
				# Compare against the charmap rather than the name, so
				# that en_US.ISO-8859-1 finds the "en_US ISO-8859-1"
				# entry.
				normalized=${charmap//[^[:alnum:]]}
				[[ ${normalized,,} == "${codeset}" ]] || continue
			else
				# Without a codeset, only the entry that has none in
				# its name matches, e.g. "en_US ISO-8859-1" and not
				# "en_US.UTF-8 UTF-8".
				[[ -n ${BASH_REMATCH[3]} ]] && continue
			fi
			found=1
			break
		fi
	done < "${supported}"

	if [[ -z ${found} ]]; then
		${log} "${FUNCNAME}: ${name}: not listed in ${supported}"
		return 1
	fi

	local msg line
	if ! msg=$(localedef -i "${lang}${modifier}" -f "${charmap}" "${out}" 2>&1)
	then
		rm -rf "${out}" || die
		${log} "${FUNCNAME}: ${name}: localedef failed:"
		while read -r line; do
			${log} "${line}"
		done <<< "${msg}"
		return 1
	fi
}

# @FUNCTION: elocale_gen
# @USAGE: [--set <variable>] <locale>...
# @RETURN: 0 if the locales are available, 1 if they are not
# @DESCRIPTION:
# Generate the given locales into a directory under ${T} and export LOCPATH
# so that programs run afterwards can use them. Locales are named as in
# /usr/share/i18n/SUPPORTED, e.g. cs_CZ.UTF-8, en_US or de_DE@euro. Other
# spellings of the codeset, e.g. cs_CZ.utf8, are accepted.
#
# Setting LOCPATH hides the system's locales, so the locales in use by the
# environment and C.UTF-8 are generated as well. Any other locale that is
# needed must be requested, even if it happens to be installed.
#
# "locale -a" does not honor LOCPATH and never lists the generated locales.
#
# Dies if a locale cannot be generated, unless called under nonfatal.
#
# Only glibc can compile locales. With any other libc nothing is generated
# and LOCPATH is left alone. Returns 0 if "locale -a" lists all of the given
# locales, e.g. because sys-apps/musl-locales provides them, and otherwise 1
# without dying, so that the caller can skip the affected tests.
#
# With --set, the variable, which must be LANG or one of LC_*, is exported
# with the first locale as its value. Use this rather than assigning the
# variable. LOCPATH only takes effect in programs started afterwards, so bash
# itself cannot find the generated locales and warns that it cannot change
# locale whenever such a variable is assigned. For the same reason, bash keeps
# using its previous locale. If the libc is not glibc, the variable is
# exported whether or not the locale is available.
#
# LOCPATH is saved with the rest of the environment, and the directory is
# gone by the time pkg_prerm and pkg_postrm run. Declare it local in the
# calling phase, as in the examples, along with the variable given to --set,
# which would otherwise cause the warning again whenever the environment is
# loaded. If the locales are needed in several phases, call elocale_gen in
# each of them. Locales that are already there are not generated again.
# pkg_setup is not suitable, since it runs as root and for binary packages.
#
# May be called more than once. Locales accumulate.
elocale_gen() {
	debug-print-function ${FUNCNAME} "$@"

	local setvar
	if [[ ${1} == --set ]]; then
		setvar=${2}
		[[ ${setvar} =~ ^(LANG|LC_[A-Z]+)$ ]] ||
			die "${FUNCNAME}: --set needs LANG or LC_*, not '${setvar}'"
		shift 2
	fi

	[[ $# -ge 1 ]] || die "${FUNCNAME}: at least one locale needed"

	if ! use elibc_glibc; then
		[[ -n ${setvar} ]] && export "${setvar}=${1}"

		local name
		for name; do
			if ! _locale-utils_installed "${name}"; then
				debug-print "${FUNCNAME}: ${name}: not listed by locale -a"
				return 1
			fi
		done
		return 0
	fi

	local dir=${T}/locale
	mkdir -p "${dir}" || die

	local name var
	for var in LANG "${!LC_@}"; do
		name=${!var}
		[[ -z ${name} || ${name} == @(C|POSIX) ]] && continue
		# Best effort. The locale may not be available on the system
		# either, in which case nothing is lost.
		_locale-utils_gen debug-print "${dir}" "${name}"
	done

	for name in C.UTF-8 "$@"; do
		einfo "Generating locale ${name}"
		if ! _locale-utils_gen eerror "${dir}" "${name}"; then
			die -n "${FUNCNAME}: failed to generate locale ${name}"
			return 1
		fi
	done

	export LOCPATH=${dir}
	if [[ -n ${setvar} ]]; then
		# bash does not see LOCPATH and warns if the locale is not
		# installed on the system.
		export "${setvar}=${1}" 2>/dev/null
	fi
	return 0
}

fi
