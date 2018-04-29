# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dict.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original author: Seemant Kulleen
# @BLURB: Ease the installation of dict translation dictionaries
# @DESCRIPTION:
# This eclass exists to ease the installation of dict translation
# dictionaries.  The only variables which need to be defined in the actual
# ebuilds is DICTS if the package ships more than one dictionary which
# cannot be determined from ${PN}.

# @ECLASS-VARIABLE: DICTS
# @DESCRIPTION:
# Array of dictionary file names (foo.dict.dz and foo.index) to be installed
# during dict_src_install

if [[ -z ${_DICT_ECLASS} ]]; then
_DICT_ECLASS=1

case ${EAPI:-0} in
	6|7) ;;
	0|1|2|3|4|5) die "${ECLASS}.eclass is banned in EAPI=${EAPI}" ;;
esac

MY_P=${PN/dictd-/}
DICTS=( ${MY_P} )

DESCRIPTION="${MY_P} dictionary for dictd"
HOMEPAGE="http://www.dict.org"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

RDEPEND="app-text/dictd"

S="${WORKDIR}"

# @FUNCTION: dict_src_install
# @DESCRIPTION:
# The dict src_install function, which is exported
dict_src_install() {
	insinto /usr/share/dict
	doins ${DICTS[@]/%/.dict.dz}
	doins ${DICTS[@]/%/.index}
	einstalldocs
}

EXPORT_FUNCTIONS src_install

fi
