# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MYSPELL_DICT=(
	"${P}/fo_FO.aff"
	"${P}/fo_FO.dic"
)

MYSPELL_HYPH=(
	"hyph_fo_FO.dic"
)

MYSPELL_THES=(
)

inherit myspell-r2

DESCRIPTION="Faroese dictionaries for myspell/hunspell"
HOMEPAGE="http://fo.speling.org/"
SRC_URI="
	http://fo.speling.org/filer/${P}.tar.bz2
	http://fo.speling.org/filer/hyph_fo_FO-20040420a.zip
"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
