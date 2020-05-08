# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://cgit.libimobiledevice.org/${PN}.git/snapshot/${P}.tar.bz2"
LICENSE="GPL-2+ LGPL-2.1+" # tools/*.c is GPL-2+, rest is LGPL-2.1+
SLOT="0/6" # based on SONAME of libusbmuxd.so
KEYWORDS="~amd64 ~arm ~arm64 ppc ~ppc64 ~x86"
IUSE="static-libs"

RDEPEND="
	>=app-pda/libplist-2.1.0:=
	!<app-pda/usbmuxd-1.0.8_p1
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(usex kernel_linux '' --without-inotify)
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
