# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit myspell-r2

DESCRIPTION="English dictionaries for myspell/hunspell"
HOMEPAGE="
	https://extensions.libreoffice.org/extensions/english-dictionaries
	https://github.com/marcoagpinto/aoo-mozilla-en-dict
	https://proofingtoolgui.org
"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/41/1730452952/dict-en-20241101_lo.oxt"

LICENSE="BSD MIT LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

PLOCALES=( "en-AU" "en-CA" "en-GB" "en-US" "en-ZA" )
IUSE="${PLOCALES[*]/#/+l10n_}"
REQUIRED_USE="|| ( ${PLOCALES[*]/#/l10n_} )"

src_prepare() {
	# This thesaurus is used by all the English dictionaries, see
	# ./dictionaries.xcu in the distfile, lines 71-81.
	MYSPELL_THES=(
		"th_en_US_v2.dat"
		"th_en_US_v2.idx"
	)

	local non_us_dic_used=0
	local mylinguas
	for lang in "${PLOCALES[@]}"; do
		mylinguas="${lang/-/_}"
		if use "l10n_${lang}"; then
			MYSPELL_DICT+=( "${mylinguas}.aff" "${mylinguas}.dic" )
			if [[ ${lang} == en-US ]]; then
				MYSPELL_HYPH=( "hyph_en_US.dic" )
			else
				non_us_dic_used=1
			fi
		else
			rm "README_${mylinguas}.txt" || die
			if [[ ${lang} == "en-US" ]]; then
				rm "README_hyph_en_US.txt" || die
			elif [[ ${lang} == "en-GB" ]]; then
				rm "README_en_GB_thes.txt" || die
			fi
		fi
	done

	if [[ non_us_dic_used -eq 1 ]]; then
		# This is used by every English variety, except for the en-US, see
		# ./dictionaries.xcu, lines 60-70.
		MYSPELL_HYPH+=( "hyph_en_GB.dic" )
	else
		rm "README_hyph_en_GB.txt" || die
	fi

	default
}
