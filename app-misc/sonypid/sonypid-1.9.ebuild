# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tool to use the Sony Vaios jog-dial as a mouse-wheel"
HOMEPAGE="https://www.popies.net/sonypi/"
SRC_URI="https://www.popies.net/sonypi/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="x11-libs/libXtst"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin sonypid
	dodoc AUTHORS CHANGES
}
