# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"pl_PL.aff"
	"pl_PL.dic"
)

MYSPELL_HYPH=(
	"hyph_pl_PL.dic"
)

MYSPELL_THES=(
	"th_pl_PL_v2.dat"
)

inherit myspell-r2

DESCRIPTION="Polish dictionaries for myspell/hunspell"
HOMEPAGE="https://sjp.pl/slownik/en/"
SRC_URI="https://github.com/scardracs/gentoo-packages/releases/download/pl-${PV}/${P}.tar.gz"

LICENSE="CC-SA-1.0 Apache-2.0 LGPL-2.1+ GPL-2+ MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
