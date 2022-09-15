# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit myspell-r2

MY_PV=$(ver_rs 1- -)	# YYYY-MM-DD

DESCRIPTION="German (AT,CH,DE) dictionaries for myspell/hunspell"
HOMEPAGE="
	https://extensions.libreoffice.org/extensions/german-de-at-frami-dictionaries
	https://extensions.libreoffice.org/extensions/german-de-ch-frami-dictionaries
	https://extensions.libreoffice.org/extensions/german-de-de-frami-dictionaries
"
SRC_URI="
	l10n_de? (
		https://extensions.libreoffice.org/extensions/german-de-at-frami-dictionaries/$(ver_rs 1 -)/@@download/file/dict-de_AT-frami_${MY_PV}.oxt
		https://extensions.libreoffice.org/extensions/german-de-ch-frami-dictionaries/$(ver_rs 1 -)/@@download/file/dict-de_CH-frami_${MY_PV}.oxt
		https://extensions.libreoffice.org/extensions/german-de-de-frami-dictionaries/${MY_PV}/@@download/file/dict-de_DE-frami_${MY_PV}.oxt )
	l10n_de-AT? ( https://extensions.libreoffice.org/extensions/german-de-at-frami-dictionaries/$(ver_rs 1 -)/@@download/file/dict-de_AT-frami_${MY_PV}.oxt )
	l10n_de-CH? ( https://extensions.libreoffice.org/extensions/german-de-ch-frami-dictionaries/$(ver_rs 1 -)/@@download/file/dict-de_CH-frami_${MY_PV}.oxt )
	l10n_de-DE? ( https://extensions.libreoffice.org/extensions/german-de-de-frami-dictionaries/${MY_PV}/@@download/file/dict-de_DE-frami_${MY_PV}.oxt )
"

LICENSE="GPL-3 GPL-2 LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

PLOCALES=( "de-AT" "de-CH" "de-DE" )
IUSE+="+l10n_de ${PLOCALES[@]/#/l10n_}"
REQUIRED_USE="|| ( l10n_de ${PLOCALES[@]/#/l10n_} )"

src_prepare() {
	# fixing file names
	for i in *_frami.*; do
		mv "${i}" "${i/_frami}" || die
	done

	MYSPELL_DICT=( )
	MYSPELL_HYPH=( )
	MYSPELL_THES=( )
	for lang in "${PLOCALES[@]}"; do
		local mylinguas="${lang//-/_}"
		if use "l10n_${lang}" || use l10n_de; then
			MYSPELL_DICT+=( "${mylinguas}.aff" "${mylinguas}.dic" )
			MYSPELL_HYPH+=( "hyph_${mylinguas}.dic" )
			MYSPELL_THES+=( "th_${mylinguas}_v2.dat" "th_${mylinguas}_v2.idx" )
		fi
	done

	default
}
