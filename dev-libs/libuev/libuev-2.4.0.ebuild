# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Lightweight event loop library for Linux epoll() family APIs"
HOMEPAGE="https://github.com/troglobit/libuev"
SRC_URI="https://github.com/troglobit/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs"

src_configure() {
	econf --enable-static=$(usex static-libs)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
	rm "${ED}"/usr/share/doc/${PF}/LICENSE || die
}
