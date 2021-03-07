# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: aspell-dict-r1.eclass
# @MAINTAINER:
# Conrad Kostecki <conikost@gentoo.org>
# @AUTHOR:
# Seemant Kulleen <seemant@gentoo.org>
# David Seifert <soap@gentoo.org>
# Conrad Kostecki <conikost@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: An eclass to streamline the construction of ebuilds for new aspell dictionaries.
# @DESCRIPTION:
# The aspell-dict-r1 eclass is designed to streamline the construction of ebuilds
# for the new aspell dictionaries (from gnu.org) which support aspell-0.50.
# Support for aspell-0.60 has been added by Sergey Ulanov.

# @ECLASS-VARIABLE: ASPELL_LANG
# @REQUIRED
# @DESCRIPTION:
# Pure cleartext string that is included into DESCRIPTION.
# This is the name of the language, for instance "Hungarian".
# Needs to be defined before inheriting the eclass.

# @ECLASS-VARIABLE: ASPELL_SPELLANG
# @DESCRIPTION:
# Short (readonly) form of the language code, generated from ${PN}.
# For instance, 'aspell-hu' yields to the value 'hu'.
readonly ASPELL_SPELLANG="${PN/aspell-/}"

# @ECLASS-VARIABLE: ASPELL_VERSION
# @DESCRIPTION:
# What major version of aspell is this dictionary for? Valid values are 5, 6 or empty.
# This value is used to construct SRC_URI strings.
# If the value needs to be overridden, it needs to be overridden before inheriting the eclass.
: ${ASPELL_VERSION:-6}

case ${EAPI:-0} in
	0|1|2|3|4|5)
		die "Unsupported EAPI=${EAPI} (obsolete) for ${ECLASS}"
		;;
	6|7)
		;;
	*)
		die "Unknown EAPI=${EAPI} for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS src_configure src_install

if [[ ! ${_ASPELL_DICT_R1} ]]; then

[[ ! -z "${ASPELL_VERSION}" && "${ASPELL_VERSION}" != [56] ]] && die "Unsupported ASPELL_VERSION=${ASPELL_VERSION} for ${ECLASS}"

# Most of those aspell packages have an idiosyncratic versioning scheme,
# where the last separating version separator is replaced by a '-'.
_ASPELL_P="aspell${ASPELL_VERSION}-${PN/aspell-/}-${PV%.*}-${PV##*.}"

DESCRIPTION="Aspell (${ASPELL_LANG}) language dictionary"
HOMEPAGE="http://aspell.net"
SRC_URI="mirror://gnu/aspell/dict/${ASPELL_SPELLANG}/${_ASPELL_P}.tar.bz2"
S="${WORKDIR}/${_ASPELL_P}"

unset _ASPELL_P

SLOT="0"

RDEPEND="app-text/aspell"
DEPEND="${RDEPEND}"
unset _ASPELL_MAJOR_VERSION

# @FUNCTION: aspell-dict-r1_src_configure
# @DESCRIPTION:
# The aspell-dict-r1 src_configure function which is exported.
aspell-dict-r1_src_configure() {
	# Since it's a non-autoconf based script, 'econf' cannot be used.
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
