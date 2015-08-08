# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_P="OOo-full-pack-bg-${PV}"

MYSPELL_DICT=(
	"bg_BG.aff"
	"bg_BG.dic"
)

MYSPELL_HYPH=(
	"hyph_bg_BG.dic"
)

MYSPELL_THES=(
	"th_bg_BG.dat"
	"th_bg_BG.idx"
)

inherit myspell-r2

DESCRIPTION="Bulgarian dictionaries for myspell/hunspell"
HOMEPAGE="http://bgoffice.sourceforge.net/"
SRC_URI="mirror://sourceforge/bgoffice/${MY_P}.zip"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# remove licenses that are suffixed with txt
	# so they are not picked by install dodoc
	rm -rf *.txt
}
