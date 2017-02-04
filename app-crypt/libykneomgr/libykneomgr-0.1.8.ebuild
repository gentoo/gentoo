# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit udev

DESCRIPTION="YubiKey NEO CCID Manager C Library"
HOMEPAGE="https://developers.yubico.com/libykneomgr/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="kernel_linux"

RDEPEND="sys-apps/pcsc-lite
	dev-libs/libzip"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	>=app-crypt/ccid-1.4.18[usb]"

src_configure() {
	econf \
		--with-backend=pcsc \
		--disable-static
}
