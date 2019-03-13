# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: freedict.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original author: Seemant Kulleen
# @SUPPORTED_EAPIS: 6
# @BLURB: Ease the installation of freedict translation dictionaries
# @DESCRIPTION:
# This eclass exists to ease the installation of freedict translation
# dictionaries.  The only variables which need to be defined in the actual
# ebuilds are FORLANG and TOLANG for the source and target languages,
# respectively.

# @ECLASS-VARIABLE: FORLANG
# @DESCRIPTION:
# Please see above for a description.

# @ECLASS-VARIABLE: TOLANG
# @DESCRIPTION:
# Please see above for a description.

case ${EAPI:-0} in
	6) ;;
	*) die "${ECLASS}.eclass is banned in EAPI=${EAPI}" ;;
esac

MY_P=${PN/freedict-/}

DESCRIPTION="Freedict for language translation from ${FORLANG} to ${TOLANG}"
HOMEPAGE="http://freedict.sourceforge.net/"
SRC_URI="http://freedict.sourceforge.net/download/linux/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="app-text/dictd"

S="${WORKDIR}"

# @FUNCTION: freedict_src_install
# @DESCRIPTION:
# The freedict src_install function, which is exported
freedict_src_install() {
	insinto /usr/$(get_libdir)/dict
	doins ${MY_P}.dict.dz
	doins ${MY_P}.index
}

EXPORT_FUNCTIONS src_install
