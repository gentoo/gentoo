# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: freedict.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original author: Seemant Kulleen
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Ease the installation of freedict translation dictionaries
# @DESCRIPTION:
# This eclass exists to ease the installation of freedict translation
# dictionaries.  The only variables which need to be defined in the actual
# ebuilds are FORLANG and TOLANG for the source and target languages,
# respectively.

# @ECLASS-VARIABLE: FREEDICT_P
# @DESCRIPTION:
# Strips PN of 'freedict' prefix, to be used in SRC_URI and doins
FREEDICT_P=${PN/freedict-/}

# @ECLASS-VARIABLE: FORLANG
# @DEFAULT_UNSET
# @DESCRIPTION:
# DEPRECATED: Cleanup after EAPI-7 removal.

# @ECLASS-VARIABLE: TOLANG
# @DEFAULT_UNSET
# @DESCRIPTION:
# DEPRECATED: Cleanup after EAPI-7 removal.

case ${EAPI:-0} in
	6)
		DESCRIPTION="Freedict for language translation from ${FORLANG} to ${TOLANG}"
		;;
	7)
		[[ ${FORLANG} ]] && die "FORLANG is banned, set DESCRIPTION instead"
		[[ ${TOLANG} ]] && die "TOLANG is banned, set DESCRIPTION instead"
		;;
	*) die "${ECLASS}.eclass is banned in EAPI=${EAPI}" ;;
esac

HOMEPAGE="http://freedict.sourceforge.net/en/"
SRC_URI="http://freedict.sourceforge.net/download/linux/${FREEDICT_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="app-text/dictd"

S="${WORKDIR}"

# @FUNCTION: freedict_src_install
# @DESCRIPTION:
# Installs translation specific dict.dz and index files.
freedict_src_install() {
	insinto /usr/$(get_libdir)/dict
	doins ${FREEDICT_P}.dict.dz
	doins ${FREEDICT_P}.index
}

EXPORT_FUNCTIONS src_install
