# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MYSPELL_DICT=(
	"da_DK.aff"
	"da_DK.dic"
)

MYSPELL_HYPH=(
	"hyph_da_DK.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Danish dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/stavekontrolden-danish-dictionary"
SRC_URI="http://extensions.libreoffice.org/extension-center/stavekontrolden-danish-dictionary/pscreleasefolder.2011-09-30.0280139318/2.1/dict-da-${PV}.oxt"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
