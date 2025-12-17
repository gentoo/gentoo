# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: plocale.eclass
# @MAINTAINER:
# Ulrich Müller <ulm@gentoo.org>
# @AUTHOR:
# Ben de Groot <yngwin@gentoo.org>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: convenience functions to handle localizations
# @DESCRIPTION:
# The plocale (localization) eclass offers a number of functions to more
# conveniently handle localizations (translations) offered by packages.
# These are meant to prevent code duplication for such boring tasks as
# determining the cross-section between the user's set LINGUAS and what
# is offered by the package.
#
# Typical usage in an ebuild looks like this:
#
# @CODE
#   PLOCALES="de en fr pt_BR zh_CN"
#   PLOCALE_BACKUP="en"
# @CODE
#
# There, PLOCALES is the list of locales that the package supports.
# PLOCALE_BACKUP is optional and specifies a single locale, which is
# used as a fallback if none of the PLOCALES matches the user's
# LINGUAS selection.
#
# The eclass functions then operate on the intersection of the package's
# PLOCALES with the user's LINGUAS setting.  (As a special case, if the
# LINGUAS variable is unset then all items in PLOCALES will be used,
# emulating the behaviour of gettext.)
#
# In the following simple example, locale specific README files
# (e.g. README.de, README.en) are added to the DOCS variable:
#
# @CODE
#   my_add_to_docs() {
#       DOCS+=( ${1}.${2} )
#   }
#   plocale_for_each_locale my_add_to_docs README
# @CODE
#
# A complementary function plocale_for_each_disabled_locale exists as
# well, which operates on the set difference of PLOCALES and LINGUAS,
# i.e. on the locales that the user hasn't enabled.  For example, it can
# be used to remove unnecessary locale files.
#
# Finally, plocale_find_changes is purely a helper function for ebuild
# maintenance.  It can be used to scan a directory for available
# translations and check if the ebuild's PLOCALES are still up to date.

if [[ -z ${_PLOCALE_ECLASS} ]]; then
_PLOCALE_ECLASS=1

case ${EAPI} in
	7|8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: PLOCALES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Variable listing the locales for which localizations are offered by
# the package.
#
# Example: PLOCALES="cy de el_GR en_US pt_BR vi zh_CN"

# @ECLASS_VARIABLE: PLOCALE_BACKUP
# @DEFAULT_UNSET
# @DESCRIPTION:
# In some cases the package fails when none of the offered PLOCALES are
# selected by the user.  In that case this variable should be set to a
# default locale (usually 'en' or 'en_US') as backup.
#
# Example: PLOCALE_BACKUP="en_US"

# @FUNCTION: plocale_for_each_locale
# @USAGE: <function> [<args>...]
# @DESCRIPTION:
# Convenience function for processing all enabled localizations.
# The parameter should be a function (defined in the consuming eclass
# or ebuild) which takes an individual locale as its (last) parameter.
#
# Example: plocale_for_each_locale install_locale
plocale_for_each_locale() {
	local locs x
	locs=$(plocale_get_locales)
	for x in ${locs}; do
		"$@" ${x} || die "failed to process enabled ${x} locale"
	done
}

# @FUNCTION: plocale_for_each_disabled_locale
# @USAGE: <function> [<args>...]
# @DESCRIPTION:
# Complementary to plocale_for_each_locale, this function will process
# locales that are disabled.  This could be used for example to remove
# locales from a Makefile, to prevent them from being built needlessly.
plocale_for_each_disabled_locale() {
	local locs x
	locs=$(plocale_get_locales disabled)
	for x in ${locs}; do
		"$@" ${x} || die "failed to process disabled ${x} locale"
	done
}

# @FUNCTION: plocale_find_changes
# @USAGE: <translations dir> <filename pre pattern> <filename post pattern>
# @DESCRIPTION:
# Ebuild maintenance helper function to find changes in package offered
# locales when doing a version bump.  This could be added for example
# to src_prepare.
#
# Example: plocale_find_changes "${S}/src/translations" "${PN}_" '.ts'
plocale_find_changes() {
	[[ $# -eq 3 ]] || die "Exactly 3 arguments are needed!"
	ebegin "Looking in ${1} for new locales"
	pushd "${1}" >/dev/null || die "Cannot access ${1}"
	local current="" x
	for x in ${2}*${3}; do
		x=${x#"${2}"}
		x=${x%"${3}"}
		current+="${x} "
	done
	popd >/dev/null || die
	# RHS will be sorted with single spaces so ensure the LHS is too
	# before attempting to compare them for equality. See bug #513242.
	# Run them both through the same sorting algorithm so we don't have
	# to worry about them being the same.
	[[ "$(printf '%s\n' ${PLOCALES} | LC_ALL=C sort)" \
		== "$(printf '%s\n' ${current} | LC_ALL=C sort)" ]]
	if ! eend $? "There are changes in locales!"; then
		eerror "This ebuild should be updated to:"
		eerror "PLOCALES=\"${current%[[:space:]]}\""
		return 1
	fi
}

# @FUNCTION: plocale_get_locales
# @USAGE: [disabled]
# @DESCRIPTION:
# Determine which LINGUAS the user has enabled that are offered by the
# package, as listed in PLOCALES, and return them.  In case no locales
# are selected, fall back on PLOCALE_BACKUP.  When the disabled argument
# is given, return the disabled locales instead of the enabled ones.
plocale_get_locales() {
	local loc locs
	if [[ -z ${LINGUAS+set} ]]; then
		# enable all if unset
		locs=${PLOCALES}
	else
		for loc in ${LINGUAS}; do
			has ${loc} ${PLOCALES} && locs+="${loc} "
		done
	fi
	[[ -z ${locs} ]] && locs=${PLOCALE_BACKUP}
	if [[ ${1} == disabled ]]; then
		local disabled_locs
		for loc in ${PLOCALES}; do
			has ${loc} ${locs} || disabled_locs+="${loc} "
		done
		locs=${disabled_locs}
	fi
	printf "%s" "${locs}"
}

fi
