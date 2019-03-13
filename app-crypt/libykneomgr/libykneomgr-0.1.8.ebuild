# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

DESCRIPTION="YubiKey NEO CCID Manager C Library"
HOMEPAGE="https://developers.yubico.com/libykneomgr/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="kernel_linux"

DEPEND="sys-apps/pcsc-lite
	dev-libs/libzip"
RDEPEND="${DEPEND}
	>=app-crypt/ccid-1.4.18[usb]"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		--with-backend=pcsc \
		--disable-static
}
