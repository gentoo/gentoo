# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MYSPELL_DICT=(
	"tn_ZA.aff"
	"tn_ZA.dic"
)

inherit myspell-r2

DESCRIPTION="Setswana dictionaries for myspell/hunspell"
HOMEPAGE="http://lingucomponent.openoffice.org/"
SRC_URI="mirror://gentoo/myspell-tn_ZA-20060316.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86"
