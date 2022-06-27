# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"nb_NO.aff"
	"nb_NO.dic"
)

MYSPELL_HYPH=(
	"hyph_nb_NO.dic"
)

MYSPELL_THES=(
	"th_nb_NO_v2.dat"
	"th_nb_NO_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Norwegian dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/en/extensions/show/norsk-stavekontroll-bokmal-og-nynorsk"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/dictionary-no-no-1-0.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
