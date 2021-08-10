# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Hadron Seedless Infrared-Safe Cone jet algorithm"
HOMEPAGE="https://siscone.hepforge.org/"
SRC_URI="https://siscone.hepforge.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	if use examples; then
		docinto examples
		dodoc examples/*.{cpp,h}
		docinto examples/events
		dodoc examples/events/*.dat
		docompress -x /usr/share/doc/${PF}/examples
	fi

	find "${ED}" -name '*.la' -delete || die
}
