# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"hr_HR.aff"
	"hr_HR.dic"
)

MYSPELL_HYPH=(
	"hyph_hr.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Croatian dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="https://extensions.openoffice.org/en/project/croatian-dictionary-and-hyphenation-patterns"
SRC_URI="mirror://sourceforge/aoo-extensions/dict-hr.oxt -> ${P}.oxt"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE=""
