# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="mouse tool for advanced features such as wheels and 3+ buttons"
HOMEPAGE="http://imwheel.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libXtst
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXext"

DEPEND="${RDEPEND}
	x11-base/xorg-proto
	>=sys-apps/sed-4"

src_prepare() {
	default
	sed -i -e "s:/etc:${D}/etc:g" Makefile.am || die
	eautoreconf
}

src_configure() {
	# don't build gpm stuff
	econf --disable-gpm --disable-gpm-doc
}
