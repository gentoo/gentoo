# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PV="${PV:0:4}-${PV:4:2}.${PV:6:2}"

inherit myspell-r2

DESCRIPTION="English dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extensions/english-dictionaries"
SRC_URI="https://extensions.libreoffice.org/extensions/english-dictionaries/${MY_PV}/@@download/file/dict-en-${PV}.oxt"

LICENSE="BSD MIT LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

PLOCALES=( "en" "en-AU" "en-CA" "en-GB" "en-US" "en-ZA" )
IUSE+="${PLOCALES[@]/#/l10n_}"
REQUIRED_USE="|| ( ${IUSE[@]} )"
RDEPEND="!<dev-libs/hyphen-2.8.8-r1"

src_prepare() {
	if use l10n_en-GB || use l10n_en; then
		MYSPELL_HYPH=( "hyph_en_GB.dic" )
	fi
	if use l10n_en-US || use l10n_en; then
		MYSPELL_HYPH=( "hyph_en_US.dic" )
		MYSPELL_THES=(
			"th_en_US_v2.dat"
			"th_en_US_v2.idx"
		)
	fi

	MYSPELL_DICT=( )
	for lang in "${PLOCALES[@]}"; do
		if [[ "${lang}" == "en" ]]; then
			continue
		fi
		local mylinguas="${lang//-/_}"
		if use "l10n_${lang}" || use l10n_en; then
			MYSPELL_DICT+=( "${mylinguas}.aff" "${mylinguas}.dic" )
		else
			rm "README_${mylinguas}.txt" || die
			if [[ ${lang} == "en-US" ]]; then
				rm "README_hyph_en_US.txt" || die
			fi
			if [[ ${lang} == "en-GB" ]]; then
				rm "README_hyph_en_GB.txt" || die
				rm "README_en_GB_thes.txt" || die
			fi
		fi
	done

	default
}
