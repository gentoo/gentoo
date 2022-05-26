# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"cs_CZ.aff"
	"cs_CZ.dic"
)

MYSPELL_HYPH=(
	"hyph_cs_CZ.dic"
)

MYSPELL_THES=(
	"thes_cs_CZ.dat"
)

inherit myspell-r2

DESCRIPTION="Czech dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extensions/czech-dictionaries"
SRC_URI="https://extensions.libreoffice.org/extensions/czech-dictionaries/2018.10/@@download/file/czech-dictionaries.oxt -> ${P}.zip"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
