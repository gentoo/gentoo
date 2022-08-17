# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"ku_TR/ku_TR.aff"
	"ku_TR/ku_TR.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Kurdish dictionaries for myspell/hunspell"
HOMEPAGE="https://code.google.com/p/hunspell-ku/"
SRC_URI="mirror://sourceforge/myspellkurdish/ku_TR-${PV/./}.zip"

LICENSE="GPL-3 LGPL-3 MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
