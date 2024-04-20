# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"af_ZA.aff"
	"af_ZA.dic"
)

MYSPELL_HYPH=(
	"hyph_af_ZA.dic"
)

inherit myspell-r2

DESCRIPTION="Afrikaans dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.openoffice.org/project/dict_af"
SRC_URI="mirror://sourceforge/aoo-extensions/1109/0/dict-af.oxt"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
