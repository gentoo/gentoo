# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV::4}.${PV:4:2}.${PV:6}

MYSPELL_DICT=(
	"zu_ZA.aff"
	"zu_ZA.dic"
)

inherit myspell-r2

DESCRIPTION="Zulu dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="https://extensions.openoffice.org/en/project/zulu-spell-checker"
SRC_URI="https://downloads.sourceforge.net/aoo-extensions/dict-zu_za-${MY_PV}.oxt -> ${P}.oxt"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86"
