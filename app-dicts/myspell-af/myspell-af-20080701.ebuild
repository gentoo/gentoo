# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-af/myspell-af-20080701.ebuild,v 1.1 2012/06/13 15:53:55 scarabeus Exp $

EAPI=4

MYSPELL_DICT=(
	"af_ZA.aff"
	"af_ZA.dic"
)

MYSPELL_HYPH=(
	"hyph_af_ZA.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Afrikaans dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.services.openoffice.org/project/dict_af"
SRC_URI="mirror://sourceforge/aoo-extensions/1109/0/dict-af.oxt"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
