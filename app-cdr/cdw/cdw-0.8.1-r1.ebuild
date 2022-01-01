# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="An ncurses based console frontend for cdrtools and dvd+rw-tools"
HOMEPAGE="http://cdw.sourceforge.net"
SRC_URI="mirror://sourceforge/cdw/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="
	app-cdr/cdrtools
	app-cdr/dvd+rw-tools
	dev-libs/libburn
	dev-libs/libcdio:=[-minimal]
	sys-libs/ncurses:0=[unicode]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-0.8.1-fix-ar-call.patch" )

DOCS=( AUTHORS ChangeLog NEWS README THANKS cdw.conf )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}
