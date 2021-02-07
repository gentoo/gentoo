# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: font-ebdftopcf.eclass
# @MAINTAINER:
# Fonts team <fonts@gentoo.org>
# @AUTHOR:
# Author: Robin H. Johnson <robbat2@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: An eclass to make PCF font generator from BDF uniform and optimal.
# @DESCRIPTION:
# The manpage for this eclass is in media-gfx/ebdftopcf.
#
# Inherit this eclass after font.eclass.

case ${EAPI:-0} in
	[0-5]) die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}" ;;
	[6-7]) ;;
	*)     die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}" ;;
esac

EXPORT_FUNCTIONS src_compile

if [[ ! ${_FONT_EBDFTOPCF_ECLASS} ]]; then

# if USE="-X", this eclass is basically a no-op, since bdftopcf requires Xorg.
IUSE="X"

# Variable declarations
BDEPEND="X? ( media-gfx/ebdftopcf )"
[[ ${EAPI} == 6 ]] && DEPEND="${BDEPEND}"

#
# Public functions
#
ebdftopcf() {
	local bdffiles
	bdffiles="$@"
	[[ -z ${bdffiles} ]] && die "No BDF files specified."
	emake -f "${EPREFIX}"/usr/share/ebdftopcf/Makefile.ebdftopcf \
		BDFFILES="${bdffiles}" \
		BDFTOPCF_PARAMS="${BDFTOPCF_PARAMS}"
}

#
# Public inheritable functions
#
font-ebdftopcf_src_compile() {
	FONT_SUFFIX="$(usex X pcf.gz bdf)"

	if use X; then
		[[ -z ${BDFFILES} ]] && BDFFILES="$(find . -name '*.bdf')"
		ebdftopcf ${BDFFILES}
	fi
}

_FONT_EBDFTOPCF_ECLASS=1
fi
