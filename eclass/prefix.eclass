# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: prefix.eclass
# @MAINTAINER:
# Feel free to contact the Prefix team through <prefix@gentoo.org> if
# you have problems, suggestions or questions.
# @BLURB: Eclass to provide Prefix functionality
# @DESCRIPTION:
# Gentoo Prefix allows users to install into a self defined offset
# located somewhere in the filesystem.  Prefix ebuilds require
# additional functions and variables which are defined by this eclass.

# @ECLASS-VARIABLE: EPREFIX
# @DESCRIPTION:
# The offset prefix of a Gentoo Prefix installation.  When Gentoo Prefix
# is not used, ${EPREFIX} should be "".  Prefix Portage sets EPREFIX,
# hence this eclass has nothing to do here in that case.
# Note that setting EPREFIX in the environment with Prefix Portage sets
# Portage into cross-prefix mode.
if [[ ! ${EPREFIX+set} ]]; then
	export EPREFIX=''
fi


# @FUNCTION: eprefixify
# @USAGE: <list of to be eprefixified files>
# @DESCRIPTION:
# replaces @GENTOO_PORTAGE_EPREFIX@ with ${EPREFIX} for the given files,
# dies if no arguments are given, a file does not exist, or changing a
# file failed.
eprefixify() {
	[[ $# -lt 1 ]] && die "at least one argument required"

	einfo "Adjusting to prefix ${EPREFIX:-/}"
	local x
	for x in "$@" ; do
		if [[ -e ${x} ]] ; then
			ebegin "  ${x##*/}"
			sed -i -e "s|@GENTOO_PORTAGE_EPREFIX@|${EPREFIX}|g" "${x}"
			eend $? || die "failed to eprefixify ${x}"
		else
			die "${x} does not exist"
		fi
	done

	return 0
}

# @FUNCTION: hprefixify
# @USAGE: [ -w <line match> ] [ -e <extended regex> ] [ -q <quotation char> ] <list of files>
# @DESCRIPTION:
# Tries a set of heuristics to prefixify the given files. Dies if no
# arguments are given, a file does not exist, or changing a file failed.
#
# Additional extended regular expression can be passed by -e or
# environment variable PREFIX_EXTRA_REGEX.  The default heuristics can
# be constrained to lines that match a sed expression passed by -w or
# environment variable PREFIX_LINE_MATCH.  Quotation characters can be
# specified by -q or environment variable PREFIX_QUOTE_CHAR, unless
# EPREFIX is empty.
#
# @EXAMPLE:
# Only prefixify the 30th line,
#   hprefixify -w 30 configure
# Only prefixify lines that contain "PATH",
#   hprefixify -w "/PATH/" configure
# Also delete all the /opt/gnu search paths,
#   hprefixify -e "/\/opt\/gnu/d" configure
# Quote the inserted EPREFIX
#   hprefixify -q '"' etc/profile
hprefixify() {
	use prefix || return 0

	local xl=() x
	while [[ $# -gt 0 ]]; do
		case $1 in
			-e) local PREFIX_EXTRA_REGEX="$2"
				shift
				;;
			-w) local PREFIX_LINE_MATCH="$2"
				shift
				;;
			-q) local PREFIX_QUOTE_CHAR="${EPREFIX:+$2}"
				shift
				;;
			*)
				xl+=( "$1" )
				;;
		esac
		shift
	done
	local dirs="/(usr|lib(|[onx]?32|n?64)|etc|bin|sbin|var|opt|run)" \
		  eprefix="${PREFIX_QUOTE_CHAR}${EPREFIX}${PREFIX_QUOTE_CHAR}"

	[[ ${#xl[@]} -lt 1 ]] && die "at least one file operand is required"
	einfo "Adjusting to prefix ${EPREFIX:-/}"
	for x in "${xl[@]}" ; do
		if [[ -e ${x} ]] ; then
			ebegin "  ${x##*/}"
			sed -r \
				-e "${PREFIX_LINE_MATCH}s,([^[:alnum:]}\)\.])${dirs},\1${eprefix}/\2,g" \
				-e "${PREFIX_LINE_MATCH}s,^${dirs},${eprefix}/\1," \
				-e "${PREFIX_EXTRA_REGEX}" \
				-i "${x}"
			eend $? || die "failed to prefixify ${x}"
		else
			die "${x} does not exist"
		fi
	done
}

# @FUNCTION: prefixify_ro
# @USAGE: prefixify_ro <file>.
# @DESCRIPTION:
# prefixify a read-only file.
# copies the files to ${T}, prefixies it, echos the new file.
# @EXAMPLE:
# doexe "$(prefixify_ro "${FILESDIR}"/fix_libtool_files.sh)"
# epatch "$(prefixify_ro "${FILESDIR}"/${PN}-4.0.2-path.patch)"
prefixify_ro() {
	if [[ -e $1 ]] ; then
		local f=${1##*/}
		cp "$1" "${T}" || die "failed to copy file"
		local x="${T}"/${f}
		# redirect to stderr because stdout is used to
		# return the prefixified file.
		if grep -qs @GENTOO_PORTAGE_EPREFIX@ "${x}" ; then
			eprefixify "${T}"/${f} 1>&2
		else
			hprefixify "${T}"/${f} 1>&2
		fi
		echo "${x}"
	else
		die "$1 does not exist"
	fi
}
# vim: tw=72:
