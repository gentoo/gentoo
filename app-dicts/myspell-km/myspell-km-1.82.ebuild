# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"km_KH.aff"
	"km_KH.dic"
)

MYSPELL_HYPH=(
	"hyph_km_KH.dic"
)

inherit myspell-r2

DESCRIPTION="Khmer dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/extension-center/khmer-spelling-checker-sbbic-version"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/sbbic-khmer-spelling-checker-libreoffice-1-82.oxt"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

LICENSE="GPL-3"
SLOT="0"
