# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://www.libimobiledevice.org/"
SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2"

# tools/iproxy.c is GPL-2+, everything else is LGPL-2.1+
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/4" # based on SONAME of libusbmuxd.so
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86"
IUSE="kernel_linux static-libs"

RDEPEND="
	>=app-pda/libplist-1.11:=
	virtual/libusb:1
	!<app-pda/usbmuxd-1.0.8_p1
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/os-headers
	virtual/pkgconfig
"

src_configure() {
	local myeconfargs=( $(use_enable static-libs static) )
	use kernel_linux || myeconfargs+=( --without-inotify )

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	if ! use static-libs; then
		find "${D}" -name '*.la' -type f -delete || die
	fi
}
