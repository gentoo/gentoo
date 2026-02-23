# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Modbus library which supports RTU communication over a serial line or a TCP link"
HOMEPAGE="https://libmodbus.org/"
SRC_URI="https://github.com/stephane/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="static-libs test"
# Tests fail at least when run via the ebuild w/ a timeout assertion being hit
# See https://github.com/stephane/libmodbus/issues/791 and https://github.com/stephane/libmodbus/pull/794
# Try again > 3.1.11.
RESTRICT="test"

PATCHES=( "${FILESDIR}/${PN}-3.1.11-cflags.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable test tests)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
