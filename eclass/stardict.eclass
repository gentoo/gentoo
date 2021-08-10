# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @NAME: stardict.eclass
# @AUTHOR: Alastair Tse <liquidx@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Convenience class to do stardict dictionary installations.
# Usage:
#   - Variables to set :
#      * FROM_LANG     -  From this language
#      * TO_LANG       -  To this language
#      * DICT_PREFIX   -  SRC_URI prefix, like "dictd_www.mova.org_"
#	   * DICT_SUFFIX   -  SRC_URI after the prefix.

case ${EAPI:-0} in
	[67]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

EXPORT_FUNCTIONS src_compile src_install

if [[ -z ${_STARDICT_ECLASS} ]] ; then
_STARDICT_ECLASS=1

RESTRICT="strip"

[ -z "${DICT_SUFFIX}" ] && DICT_SUFFIX=${PN#stardict-[[:lower:]]*-}
[ -z "${DICT_P}" ] && DICT_P=stardict-${DICT_PREFIX}${DICT_SUFFIX}-${PV}

if [ -n "${FROM_LANG}" -a -n "${TO_LANG}" ]; then
	DESCRIPTION="Stardict Dictionary ${FROM_LANG} to ${TO_LANG}"
elif [ -z "${DESCRIPTION}" ]; then
	DESCRIPTION="Another Stardict Dictionary"
fi

HOMEPAGE="http://stardict.sourceforge.net/"
SRC_URI="mirror://sourceforge/stardict/${DICT_P}.tar.bz2"
S="${WORKDIR}"/${DICT_P}

LICENSE="GPL-2"
SLOT="0"
IUSE="+zlib"

DEPEND="
	|| (
		>=app-text/stardict-2.4.2
		app-text/sdcv
		app-text/goldendict
	)
	zlib? (
		app-arch/gzip
		app-text/dictd
	)"

stardict_src_compile() {
	if use zlib; then
		for file in *.idx; do
			[[ -f $file ]] && gzip ${file}
		done
		for file in *.dict; do
			[[ -f $file ]] && dictzip ${file}
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
