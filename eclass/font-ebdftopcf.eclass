# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: font-ebdftopcf.eclass
# @MAINTAINER:
# fonts@gentoo.org
# @AUTHOR:
# Robin H. Johnson <robbat2@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass to make PCF font generator from BDF uniform and optimal
# @DESCRIPTION:
# The manpage for this eclass is in media-gfx/ebdftopcf.
# Inherit this eclass after font.eclass

case ${EAPI} in
	7) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_FONT_EBDFTOPCF_ECLASS} ]]; then
_FONT_EBDFTOPCF_ECLASS=1

# Make dependence on Xorg optional
IUSE="X"

BDEPEND="X? ( media-gfx/ebdftopcf )"

# @FUNCTION: ebdftopcf
# @USAGE: <list of BDF files to convert>
# @DESCRIPTION:
# Convert BDF to PCF. This implicitly requires USE="X" to be enabled.
ebdftopcf() {
	debug-print-function ${FUNCNAME} "$@"

	local bdffiles="$@"
	[[ -z ${bdffiles} ]] && die "No BDF files specified"
	emake -f "${BROOT}"/usr/share/ebdftopcf/Makefile.ebdftopcf \
		BDFFILES="${bdffiles}" \
		BDFTOPCF_PARAMS="${BDFTOPCF_PARAMS}" \
		|| die "Failed to build PCF files"
}

# @FUNCTION: font-ebdftopcf_src_compile
# @DESCRIPTION:
# Default phase function to convert BDF to PCF. If USE="-X", this amounts to
# a no-op, since bdftopcf requires Xorg.
font-ebdftopcf_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	FONT_SUFFIX=$(usex X "pcf.gz" "bdf")
	if use X; then
		[[ -z ${BDFFILES} ]] && local BDFFILES="$(find . -name '*.bdf')"
		ebdftopcf ${BDFFILES}
	fi
}

fi

EXPORT_FUNCTIONS src_compile
