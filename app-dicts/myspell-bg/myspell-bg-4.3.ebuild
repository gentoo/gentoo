# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	# remove licenses that are suffixed with txt
	# so they are not picked by install dodoc
	rm -rf *.txt || die
}
