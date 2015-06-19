# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-lt/myspell-lt-1.2.1.ebuild,v 1.1 2012/07/24 08:01:32 scarabeus Exp $

EAPI=4

MYSPELL_DICT=(
	"lt_LT-${PV}/lt_LT.aff"
	"lt_LT-${PV}/lt_LT.dic"
)

MYSPELL_HYPH=(
	"hyph_lt_LT.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Lithuanian dictionaries for myspell/hunspell"
HOMEPAGE="ftp://ftp.akl.lt/ispell-lt/"
SRC_URI="
	${HOMEPAGE}/lt_LT-${PV}.zip
	${HOMEPAGE}/hyph_lt_LT.zip
"

LICENSE="BSD LPPL-1.3b"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
