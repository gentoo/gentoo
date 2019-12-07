# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools udev

DESCRIPTION="A utility for accessing various Rio media players"
HOMEPAGE="https://github.com/hjelmn/rioutil"
SRC_URI="https://github.com/hjelmn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Don't use hardcoded '/lib' libpath
	sed -e '/libdir/d' -i Makefile.am -i librioutil/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	udev_dorules "${FILESDIR}"/75-rio.rules

	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
