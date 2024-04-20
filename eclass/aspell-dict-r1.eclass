# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: aspell-dict-r1.eclass
# @MAINTAINER:
# Conrad Kostecki <conikost@gentoo.org>
# @AUTHOR:
# Seemant Kulleen <seemant@gentoo.org> (original author)
# David Seifert <soap@gentoo.org> (-r1 author)
# @SUPPORTED_EAPIS: 8
# @BLURB: An eclass to streamline the construction of ebuilds for new Aspell dictionaries.
# @DESCRIPTION:
# The aspell-dict-r1 eclass is designed to streamline the construction of ebuilds for
# the new Aspell dictionaries (from gnu.org) which support aspell-0.60.
# Support for aspell-0.60 has been added by Sergey Ulanov.

# @ECLASS_VARIABLE: ASPELL_LANG
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# Pure cleartext string that is included into DESCRIPTION.
# This is the name of the language, for instance "Hungarian".
# Needs to be defined before inheriting the eclass.

# @ECLASS_VARIABLE: ASPELL_SPELLANG
# @DESCRIPTION:
# Short (readonly) form of the language code, generated from ${PN}
# For instance, 'aspell-hu' yields the value 'hu'.
readonly ASPELL_SPELLANG=${PN/aspell-/}

# @ECLASS_VARIABLE: ASPELL_VERSION
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# What major version of Aspell is this dictionary for? Valid values are 5, 6 or undefined.
# This value is used to construct SRC_URI strings.
# If the value needs to be overridden, it needs to be overridden before inheriting the eclass.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ASPELL_DICT_R1_ECLASS} ]]; then
_ASPELL_DICT_R1_ECLASS=1

# Most of those aspell packages have an idiosyncratic versioning scheme,
# where the last separating version separator is replaced by a '-'.
_ASPELL_P=aspell${ASPELL_VERSION}-${ASPELL_SPELLANG}-${PV%.*}-${PV##*.}

DESCRIPTION="Aspell (${ASPELL_LANG}) language dictionary"
HOMEPAGE="http://aspell.net"
SRC_URI="mirror://gnu/aspell/dict/${ASPELL_SPELLANG}/${_ASPELL_P}.tar.bz2"
S="${WORKDIR}/${_ASPELL_P}"
unset _ASPELL_P

SLOT="0"

RDEPEND="app-text/aspell"
DEPEND="${RDEPEND}"

_ASPELL_MAJOR_VERSION=${ASPELL_VERSION:-6}
[[ ${_ASPELL_MAJOR_VERSION} != [56] ]] && die "Unsupported ASPELL_VERSION=${ASPELL_VERSION}"
unset _ASPELL_MAJOR_VERSION

# @FUNCTION: aspell-dict-r1_src_configure
# @DESCRIPTION:
# The aspell-dict-r1 src_configure function which is exported.
aspell-dict-r1_src_configure() {
	# configure generates lines like:
	#  `echo "ASPELL = `which $ASPELL`" > Makefile`
	sed -i -e '/.* = `which/ s:`which:`command -v:' configure || die

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

fi

EXPORT_FUNCTIONS src_configure src_install
