# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Passive per-connection tcp bandwidth monitor"
HOMEPAGE="http://www.rhythm.cx/~steve/devel/tcptrack/"
SRC_URI="http://www.rhythm.cx/~steve/devel/tcptrack/release/${PV}/source/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	net-libs/libpcap
	sys-libs/ncurses
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default

	sed -i src/Makefile.am -e 's| -Werror||g' || die

	mv configure.{in,ac} || die

	eautoreconf
}
