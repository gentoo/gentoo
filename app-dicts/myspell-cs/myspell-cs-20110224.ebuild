# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"cs_CZ.aff"
	"cs_CZ.dic"
)

MYSPELL_HYPH=(
	"hyph_cs_CZ.dic"
)

MYSPELL_THES=(
	"th_cs_CZ_v3.dat"
	"th_cs_CZ_v3.idx"
)

inherit myspell-r2

DESCRIPTION="Czech dictionaries for myspell/hunspell"
HOMEPAGE="http://www.liberix.cz/doplnky/slovniky/ooo/"
SRC_URI="http://www.liberix.cz/doplnky/slovniky/ooo/dict-cs-2.oxt -> ${P}.zip"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""
