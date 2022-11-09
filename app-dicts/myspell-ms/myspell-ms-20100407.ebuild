# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"ms_MY.aff"
	"ms_MY.dic"
)

inherit myspell-r2

DESCRIPTION="Malay dictionaries for myspell/hunspell"
LICENSE="FDL-1.2"
HOMEPAGE="https://extensions.openoffice.org/en/project/kamus-bahasa-malaysia-malay-dictionary"
SRC_URI="mirror://sourceforge/aoo-extensions/ms_my.oxt -> ${P}.oxt"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
