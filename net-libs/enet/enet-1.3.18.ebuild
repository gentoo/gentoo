# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="Relatively thin, simple and robust network communication layer on top of UDP"
HOMEPAGE="http://enet.bespin.org/ https://github.com/lsalzman/enet/"
SRC_URI="http://enet.bespin.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="1.3/8"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="static-libs"

RDEPEND="!${CATEGORY}/${PN}:0"

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
