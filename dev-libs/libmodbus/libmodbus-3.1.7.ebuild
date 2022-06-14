# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Modbus library which supports RTU communication over a serial line or a TCP link"
HOMEPAGE="https://libmodbus.org/"
SRC_URI="https://libmodbus.org/releases/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs test doc"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
"

src_configure() {
	local myeconfargs=(
		$(use_enable test tests)
		$(use_enable static-libs static)
		$(use_with doc documentation)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
