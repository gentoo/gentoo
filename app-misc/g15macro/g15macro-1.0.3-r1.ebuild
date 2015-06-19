# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/g15macro/g15macro-1.0.3-r1.ebuild,v 1.3 2012/02/14 21:22:11 scarabeus Exp $

EAPI=4

DESCRIPTION="Macro recording plugin to G15daemon"
HOMEPAGE="http://g15daemon.sourceforge.net/"
SRC_URI="mirror://sourceforge/g15daemon/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND=">=app-misc/g15daemon-1.9.0
	dev-libs/libg15
	dev-libs/libg15render
	x11-libs/libX11
	x11-proto/xextproto
	x11-proto/xproto
	x11-libs/libXtst"

RDEPEND="${DEPEND}
	sys-libs/zlib"

src_configure() {
	econf --enable-xtest
}

src_install() {
	default
	rm -rf "${ED}"/usr/share/doc/${P}
}
