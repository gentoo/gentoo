# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-he/myspell-he-2010.11.05.ebuild,v 1.2 2012/07/23 11:29:08 scarabeus Exp $

EAPI=4

MYSPELL_DICT=(
	"he_IL.aff"
	"he_IL.dic"
)

MYSPELL_HYPH=(
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Hebrew dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/hebrew-he-spell-check-dictionary"
SRC_URI="http://extensions.libreoffice.org/extension-center/hebrew-he-spell-check-dictionary/releases/${PV//./-}/hebrew-dictionary -> ${P}.oxt"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
