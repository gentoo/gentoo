# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
SRC_URI="https://extensions.libreoffice.org/assets/downloads/57/czech-dictionaries_2021-07.oxt -> ${P}.zip"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
