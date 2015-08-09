# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MYSPELL_DICT=(
	"ro_RO.aff"
	"ro_RO.dic"
)

MYSPELL_HYPH=(
	"hyph_ro_RO.dic"
)

MYSPELL_THES=(
	"th_ro_RO.dat"
	"th_ro_RO.idx"
)

inherit myspell-r2

DESCRIPTION="Romanian dictionaries for myspell/hunspell"
HOMEPAGE="http://rospell.wordpress.com/"
SRC_URI="
	mirror://sourceforge/rospell/ro_RO.${PV}.zip
	mirror://sourceforge/rospell/hyph_ro_RO.${PV}.zip
	mirror://sourceforge/rospell/th_ro_RO.3.3.zip
"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
