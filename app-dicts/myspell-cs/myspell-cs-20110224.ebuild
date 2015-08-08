# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

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
SRC_URI="${HOMEPAGE}/dict-cs-2.oxt -> ${P}.zip"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
