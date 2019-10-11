# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"${P}/lt_LT.aff"
	"${P}/lt_LT.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Lithuanian dictionaries for myspell/hunspell"
HOMEPAGE="https://launchpad.net/ispell-lt"
SRC_URI="https://launchpad.net/ispell-lt/main/${PV}/+download/${P}.zip"

LICENSE="BSD LPPL-1.3b"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""
