# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
	x11-base/xorg-proto"

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin sonypid
	dodoc AUTHORS CHANGES
}
