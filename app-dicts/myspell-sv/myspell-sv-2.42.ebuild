# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"sv_FI.aff"
	"sv_FI.dic"
	"sv_SE.aff"
	"sv_SE.dic"
)

MYSPELL_HYPH=(
	"hyph_sv_SE.dic"
)

MYSPELL_THES=(
	"th_sv_SE.dat"
	"th_sv_SE.idx"
)

inherit myspell-r2

DESCRIPTION="Swedish dictionaries for myspell/hunspell"
HOMEPAGE="
	https://extensions.libreoffice.org/extension-center/swedish-spelling-dictionary-den-stora-svenska-ordlistan
	https://extensions.libreoffice.org/extension-center/swedish-hyphenation
	https://extensions.libreoffice.org/extension-center/swedish-thesaurus-based-on-synlex
"
SRC_URI="
	https://extensions.libreoffice.org/assets/downloads/z/ooo-swedish-dict-2-42.oxt -> ${P}-dict.oxt
	https://extensions.libreoffice.org/assets/downloads/z/hyph-sv.oxt -> ${P}-hyph.oxt
	https://extensions.libreoffice.org/assets/downloads/z/swedishthesaurus.oxt -> ${P}-thes.oxt
"

LICENSE="CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

src_prepare () {
	default
	mv hyph_sv.dic hyph_sv_SE.dic || die
}
