# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"eo.aff"
	"eo.dic"
)

MYSPELL_HYPH=( "hyph_eo.dic" )

MYSPELL_THES=(
	"th_eo.dat"
	"th_eo.idx"
)

inherit myspell-r2

DESCRIPTION="Esperanto dictionaries for myspell/hunspell"
HOMEPAGE="http://nlp.fi.muni.cz/projekty/esperanto_spell_checker/"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/dict-eo.oxt"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

DOCS=( changelog.txt desc_en.txt desc_eo.txt )

src_prepare() {
	default
	rm -r license-en.txt || die # delete license
}
