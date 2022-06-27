# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"it_IT.aff"
	"it_IT.dic"
)

MYSPELL_HYPH=(
	"hyph_it_IT.dic"
)

MYSPELL_THES=(
	"th_it_IT_v2.dat"
	"th_it_IT_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Italian dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/en/extensions/show/italian-dictionary-thesaurus-hyphenation-patterns"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/874d181c_dict-it.oxt -> ${P}.oxt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

DOCS=( CHANGELOG.txt desc_en.txt desc_it.txt it_IT_notes.txt it_IT_README.txt README_hyph_it_IT.txt README.txt  )

src_prepare() {
	default
	# remove useless license files.
	rm -r ico.png it_IT_COPYING thes_gpl.txt th_it_IT_COPYING it_IT_todo.txt \
	th_it_IT_Lingua.png th_it_IT_Linguistica-Modifica.png th_it_IT_sinonimi.jpg || die
}
