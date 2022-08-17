# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"he_IL.aff"
	"he_IL.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Hebrew dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extensions/hebrew-he-spell-check-dictionary"
SRC_URI="https://extensions.libreoffice.org/extensions/hebrew-he-spell-check-dictionary/${PV//./-}/@@download/file/dict-he-${PV//./-}.oxt"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
