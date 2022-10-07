# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

DESCRIPTION="Library to access J-Link devices"
HOMEPAGE="https://gitlab.zapb.de/libjaylink/libjaylink"
SRC_URI="https://gitlab.zapb.de/libjaylink/libjaylink/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Remove -Werror from CFLAGS.
	sed -i '/^JAYLINK_CFLAGS=/s/ -Werror//' configure.ac || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	udev_dorules contrib/99-${PN}.rules
	find "${D}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
