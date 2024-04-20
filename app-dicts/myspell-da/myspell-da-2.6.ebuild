# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"da_DK.aff"
	"da_DK.dic"
)

MYSPELL_HYPH=(
	"hyph_da_DK.dic"
)

inherit myspell-r2

DESCRIPTION="Danish dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extensions/stavekontrolden-danish-dictionary"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/110/da_DK-2.6.001.oxt -> ${P}.oxt"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
