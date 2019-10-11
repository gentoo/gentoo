# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
HOMEPAGE="https://extensions.openoffice.org/en/project/irish-language-spell-checker-thesaurus-and-hyphenation-patterns"
SRC_URI="mirror://sourceforge/aoo-extensions/focloiri-gaeilge-4.8.oxt -> ${P}.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE=""
