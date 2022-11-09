# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"mk_MK.aff"
	"mk_MK.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Macedonian dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="https://extensions.openoffice.org/en/project/macedonian-spellchecker-dictionary"
SRC_URI="mirror://sourceforge/aoo-extensions/dict-mk.oxt -> ${P}.oxt"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
