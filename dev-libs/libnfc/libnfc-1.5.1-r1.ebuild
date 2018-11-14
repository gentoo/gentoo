# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="Near Field Communications (NFC) library"
HOMEPAGE="http://www.libnfc.org/"
SRC_URI="https://github.com/nfc-tools/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc pcsc-lite readline static-libs usb"

RDEPEND="pcsc-lite? ( sys-apps/pcsc-lite )
	readline? ( sys-libs/readline )
	usb? ( virtual/libusb:0 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.5.1-glibc-2.17.patch"
}

src_configure() {
	# Upstream doesn't use the right macro, so we need to force this.
	# https://code.google.com/p/libnfc/issues/detail?id=249
	export ac_cv_path_PKG_CONFIG=$(tc-getPKG_CONFIG)

	local drivers="arygon,pn532_uart"
	use pcsc-lite && drivers+=",acr122"
	use usb && drivers+=",pn53x_usb"
	econf \
		--with-drivers="${drivers}" \
		$(use_enable doc) \
		$(use_with readline) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use doc && doxygen
}

src_install() {
	default
	use static-libs || find "${ED}" -name 'lib*.la' -delete
	use doc && dohtml "${S}"/doc/html/*
}
