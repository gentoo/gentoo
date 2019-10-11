# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"sk_SK/sk_SK.aff"
	"sk_SK/sk_SK.dic"
)

MYSPELL_HYPH=(
	"hyph_sk_SK/hyph_sk_SK.dic"
)

MYSPELL_THES=(
	"thes_sk_SK_v2/th_sk_SK_v2.dat"
	"thes_sk_SK_v2/th_sk_SK_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Slovak dictionaries for myspell/hunspell"
HOMEPAGE="http://www.liberix.cz/doplnky/slovniky/ooo/"
SRC_URI="http://www.liberix.cz/doplnky/slovniky/ooo/dict-sk.oxt -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""
