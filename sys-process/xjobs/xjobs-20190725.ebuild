# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Reads commands line by line and executes them in parallel"
HOMEPAGE="http://www.maier-komor.de/xjobs.html"
SRC_URI="http://www.maier-komor.de/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

BDEPEND="sys-devel/flex"

# The ncurses/terminfo libraries are used to provide color and status
# support; but, they're detected and enabled automagically by the build
# system. Thus it would do no good to hide them behind a USE flag that
# can't be turned off.
DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/search-libtinfo-for-tigetstr-and-tparm.patch" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	use examples && dodoc -r examples
}
