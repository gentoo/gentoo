# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"sl_SI.aff"
	"sl_SI.dic"
)

MYSPELL_HYPH=(
	"hyph_sl_SI.dic"
)

MYSPELL_THES=(
	"th_sl_SI_v2.dat"
	"th_sl_SI_v2.idx"
)

inherit myspell-r2

DESCRIPTION="Slovenian dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extension-center/slovenian-dictionary-pack"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/752/pack-sl.oxt -> ${P}.oxt"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
