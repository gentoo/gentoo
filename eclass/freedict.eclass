# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: freedict.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original author: Seemant Kulleen
# @SUPPORTED_EAPIS: 7
# @BLURB: Ease the installation of freedict translation dictionaries
# @DESCRIPTION:
# This eclass exists to ease the installation of freedict translation
# dictionaries.

# @ECLASS-VARIABLE: FREEDICT_P
# @DESCRIPTION:
# Strips PN of 'freedict' prefix, to be used in SRC_URI and doins
FREEDICT_P=${PN/freedict-/}

case ${EAPI:-0} in
	7) ;;
	*) die "${ECLASS}.eclass is banned in EAPI=${EAPI}" ;;
esac

[[ ${FORLANG} ]] && die "FORLANG is banned, set DESCRIPTION instead"
[[ ${TOLANG} ]] && die "TOLANG is banned, set DESCRIPTION instead"

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
