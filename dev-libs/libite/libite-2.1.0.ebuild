# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A collection of useful BSD APIs"
HOMEPAGE="https://github.com/troglobit/libite"
SRC_URI="https://github.com/troglobit/libite/releases/download/v${PV}/${P}.tar.xz"

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
