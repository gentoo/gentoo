# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"sw_KE.aff"
	"sw_KE.dic"
	"sw_TZ.aff"
	"sw_TZ.dic"
)

inherit myspell-r2

DESCRIPTION="Kiswahili dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="https://extensions.openoffice.org/en/project/swahili-dictionary"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/swahilidictionary-2013-03-12.oxt"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
