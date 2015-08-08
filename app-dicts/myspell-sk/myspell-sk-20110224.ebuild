# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

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
SRC_URI="${HOMEPAGE}/dict-sk.oxt -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
