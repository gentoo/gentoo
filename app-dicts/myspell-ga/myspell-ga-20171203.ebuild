# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"ga_IE.aff"
	"ga_IE.dic"
)

MYSPELL_HYPH=(
	"hyph_ga_IE.dic"
)

MYSPELL_THES=(
	"th_ga_IE_v2.dat"
	"th_ga_IE_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Irish dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/en/extensions/show/irish-language-spell-checker-thesaurus-and-hyphenation-patterns"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/focloiri-gaeilge-5-0.oxt -> ${P}.oxt"

LICENSE="FDL-1.2 GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
