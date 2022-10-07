# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"lt_LT.aff"
	"lt_LT.dic"
)

MYSPELL_HYPH=(
	"hyph_lt_LT.dic"
)

inherit myspell-r2

DESCRIPTION="Lithuanian dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/en/extensions/show/lithuanian-spellcheck-and-hyphenation-dictionaries"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/openoffice-spellcheck-lt-$(ver_rs 1 '-').oxt"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

src_prepare() {
	default
	# renaming correctly
	mv lt.aff lt_LT.aff || die
	mv lt.dic lt_LT.dic || die
	mv hyph_lt.dic hyph_lt_LT.dic || die
}
