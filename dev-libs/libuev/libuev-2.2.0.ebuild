# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Lightweight event loop library for Linux"

HOMEPAGE="https://github.com/troglobit/libuev"
SRC_URI="https://github.com/troglobit/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_configure(){
	econf --enable-static=$(usex static-libs)
}

src_install(){
	default
	find "${D}" -name '*.la' -delete || die
	rm "${D}/usr/share/doc/${PF}/LICENSE" || die
}
