# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/sonypid/sonypid-1.9.ebuild,v 1.12 2012/11/25 17:41:36 ago Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="tool to use the Sony Vaios jog-dial as a mouse-wheel"
HOMEPAGE="http://www.popies.net/sonypi/"
SRC_URI="http://www.popies.net/sonypi/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="x11-libs/libXtst"
DEPEND="${RDEPEND}
	x11-proto/inputproto"

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin sonypid
	dodoc AUTHORS CHANGES
}
