# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: stardict.eclass
# @MAINTAINER:
# No maintainer <maintainer-needed@gentoo.org>
# @AUTHOR:
# Alastair Tse <liquidx@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Convenience class to do stardict dictionary installations.
# @DESCRIPTION:
# **Usage**:
#
# Set the following variables:
#
# - ``FROM_LANG``
#
# - ``TO_LANG``
#
# - ``DICT_PREFIX``
#
# - ``DICT_SUFFIX``

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_STARDICT_ECLASS} ]] ; then
_STARDICT_ECLASS=1

inherit edo

RESTRICT="strip"

# @ECLASS_VARIABLE: FROM_LANG
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# From this language name

# @ECLASS_VARIABLE: TO_LANG
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# From this language name

# @ECLASS_VARIABLE: DICT_PREFIX
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# ``SRC_URI`` prefix, like ``dictd_www.mova.org_``.

# @ECLASS_VARIABLE: DICT_SUFFIX
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# ``SRC_URI`` suffix used for dictionaries.
: ${DICT_SUFFIX:=${PN#stardict-[[:lower:]]*-}}

# @ECLASS_VARIABLE: DICT_P
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# The filestem used for downloading dictionaries from SourceForge.
: ${DICT_P:=stardict-${DICT_PREFIX}${DICT_SUFFIX}-${PV}}

: ${DESCRIPTION:="Another Stardict Dictionary"}
if [[ -n ${FROM_LANG} && -n ${TO_LANG} ]]; then
	DESCRIPTION="Stardict Dictionary ${FROM_LANG} to ${TO_LANG}"
fi

HOMEPAGE="http://stardict.sourceforge.net/"
SRC_URI="mirror://sourceforge/stardict/${DICT_P}.tar.bz2"
S="${WORKDIR}/${DICT_P}"

LICENSE="GPL-2"
SLOT="0"
IUSE="+zlib"

BDEPEND="
	|| (
		>=app-text/stardict-2.4.2
		app-text/sdcv
	)
	zlib? (
		app-arch/gzip
		app-text/dictd
	)"

stardict_src_compile() {
	local file
	if use zlib; then
		for file in *.idx; do
			[[ -f ${file} ]] && edo gzip "${file}"
		done
		for file in *.dict; do
			[[ -f ${file} ]] && edo dictzip "${file}"
		done
	fi
}

stardict_src_install() {
	insinto /usr/share/stardict/dic
	doins *.dict.dz*
	doins *.idx*
	doins *.ifo
}

fi

EXPORT_FUNCTIONS src_compile src_install
