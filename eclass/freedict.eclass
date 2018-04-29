# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: freedict.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original author: Seemant Kulleen
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

if [[ -z ${_FREEDICT_ECLASS} ]]; then
_FREEDICT_ECLASS=1

case ${EAPI:-0} in
	6) ;;
	*) die "${ECLASS}.eclass is banned in EAPI=${EAPI}" ;;
esac

inherit dict

MY_P=${PN/freedict-/}
DICTS=( ${MY_P} )

DESCRIPTION="Freedict for language translation from ${FORLANG} to ${TOLANG}"
HOMEPAGE="http://freedict.sourceforge.net/"
SRC_URI="http://freedict.sourceforge.net/download/linux/${MY_P}.tar.gz"

fi
