# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Modbus library which supports RTU communication over a serial line or a TCP link"
HOMEPAGE="https://libmodbus.org/"
SRC_URI="https://libmodbus.org/releases/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs test doc"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="doc? ( app-text/asciidoc
	app-text/xmlto )"

PATCHES=( "${FILESDIR}"/${PN}-3.1.4-doc.patch )

src_configure() {
	econf \
		$(use_enable test tests) \
		$(use_enable static-libs static) \
		$(use_with doc documentation)
}

src_install() {
	default

	use static-libs || rm "${ED}"/usr/*/libmodbus.la
}
