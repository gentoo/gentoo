# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="EmACT, a fork of Conroy's MicroEmacs"
HOMEPAGE="http://www.eligis.com/emacs/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+ BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gui"

RDEPEND="sys-libs/ncurses:0=
	gui? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	gui? ( x11-base/xorg-proto )"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		$(use_with gui x) \
		LIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_install() {
	emake INSTALL="${ED}"/usr install
	#dodoc README
}
