# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"sw_KE.aff"
	"sw_KE.dic"
	"sw_TZ.aff"
	"sw_TZ.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Kiswahili dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="https://extensions.openoffice.org/en/project/swahili-dictionary"
SRC_URI="mirror://sourceforge/aoo-extensions/dicts.sw.oxt -> ${P}.oxt"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE=""
