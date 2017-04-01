# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: aspell-dict-r1.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original author: Seemant Kulleen
#      -r1 author: David Seifert
# @BLURB: An eclass to streamline the construction of ebuilds for new aspell dicts
# @DESCRIPTION:
# The aspell-dict-r1 eclass is designed to streamline the construction of
# ebuilds for the new aspell dictionaries (from gnu.org) which support
# aspell-0.50. Support for aspell-0.60 has been added by Sergey Ulanov.

# @ECLASS-VARIABLE: ASPELL_LANG
# @REQUIRED
# @DESCRIPTION:
# Pure cleartext string that is included into DESCRIPTION. This is the name
# of the language, for instance "Hungarian". Needs to be defined before
# inheriting the eclass.

# @ECLASS-VARIABLE: ASPELL_VERSION
# @DESCRIPTION:
# What major version of aspell is this dictionary for? Valid values are 5, 6 or undefined.
# This value is used to construct SRC_URI and *DEPEND strings. If defined to 6,
# >=app-text/aspell-0.60 will be added to DEPEND and RDEPEND, otherwise,
# >=app-text/aspell-0.50 is added to DEPEND and RDEPEND. If the value is to be overridden,
# it needs to be overridden before inheriting the eclass.

case ${EAPI:-0} in
	[0-5])
		die "aspell-dict-r1.eclass is banned in EAPI ${EAPI:-0}"
		;;
	6)
		;;
	*)
		die "Unknown EAPI ${EAPI:-0}"
		;;
esac

EXPORT_FUNCTIONS src_configure src_install

if [[ ! ${_ASPELL_DICT_R1} ]]; then

# aspell packages have an idiosyncratic versioning scheme, that is
# the last separating version separator is replaced by a '-'.
_ASPELL_P=aspell${ASPELL_VERSION}-${PN/aspell-/}-${PV%.*}-${PV##*.}

# @ECLASS-VARIABLE: ASPELL_SPELLANG
# @DESCRIPTION:
# Short (readonly) form of the language code, generated from ${PN}
# For instance, 'aspell-hu' yields the value 'hu'.
readonly ASPELL_SPELLANG=${PN/aspell-/}
S="${WORKDIR}/${_ASPELL_P}"

DESCRIPTION="${ASPELL_LANG} language dictionary for aspell"
HOMEPAGE="http://aspell.net"
SRC_URI="mirror://gnu/aspell/dict/${ASPELL_SPELLANG}/${_ASPELL_P}.tar.bz2"
unset _ASPELL_P

IUSE=""
SLOT="0"

_ASPELL_MAJOR_VERSION=${ASPELL_VERSION:-5}
[[ ${_ASPELL_MAJOR_VERSION} != [56] ]] && die "${ASPELL_VERSION} is not a valid version"

RDEPEND=">=app-text/aspell-0.${_ASPELL_MAJOR_VERSION}0"
DEPEND="${RDEPEND}"
unset _ASPELL_MAJOR_VERSION

# @FUNCTION: aspell-dict-r1_src_configure
# @DESCRIPTION:
# The aspell-dict-r1 src_configure function which is exported.
aspell-dict-r1_src_configure() {
	# non-autoconf based script, cannot be used with econf
	./configure || die
}

# @FUNCTION: aspell-dict-r1_src_install
# @DESCRIPTION:
# The aspell-dict-r1 src_install function which is exported.
aspell-dict-r1_src_install() {
	default
	[[ -s info ]] && dodoc info
}

_ASPELL_DICT_R1=1
fi
