# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"sq_AL.dic"
	"sq_AL.aff"
)

inherit myspell-r2

DESCRIPTION="Albanian dictionaries for myspell/hunspell"
HOMEPAGE="http://www.shkenca.org/k6i/albanian_dictionary_for_myspell_en.html"
SRC_URI="http://www.shkenca.org/shkarkime/${PN}_AL-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

S="${WORKDIR}/${PN}_AL-${PV}"
