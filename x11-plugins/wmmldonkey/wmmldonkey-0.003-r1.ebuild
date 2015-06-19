# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmldonkey/wmmldonkey-0.003-r1.ebuild,v 1.3 2015/03/25 13:42:12 ago Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="wmmsg is a dockapp to show the up and downloadrate from your mldonkey"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/174"
SRC_URI="http://dockapps.windowmaker.org/download.php/id/298/wmmldonkey3.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	net-p2p/mldonkey"

S=${WORKDIR}/wmmldonkey3

src_prepare() {
	sed \
		-e 's:gcc:${CC} ${CFLAGS}:' \
		-e 's:gui_protocol.o endianess.o::' \
		-e 's:main.c -o wmmldonkey:main.c gui_protocol.o endianess.o -o wmmldonkey:' \
		-e 's:-lXpm -lXext:-lX11 -lXpm -lXext:' \
		-i "${S}/Makefile" || die

	tc-export CC
}

src_install() {
	dodoc CHANGELOG README
	dobin wmmldonkey
}

pkg_postinst() {
	elog "Make sure the mldonkey daemon is running before you"
	elog "attempt to run emmldonkey..."
}
