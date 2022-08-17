# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"tn_BW.aff"
	"tn_BW.dic"
)

inherit myspell-r2

DESCRIPTION="Setswana dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/en/extensions/show/setswana-spellchecker"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/hunspell-tn-2-0-0.oxt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
