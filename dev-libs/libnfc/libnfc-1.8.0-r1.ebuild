# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Near Field Communications (NFC) library"
HOMEPAGE="http://www.libnfc.org/"
SRC_URI="https://github.com/nfc-tools/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc pcsc-lite readline usb"

RDEPEND="
	pcsc-lite? ( sys-apps/pcsc-lite )
	readline? ( sys-libs/readline:= )
	usb? ( virtual/libusb:0 )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_configure() {
	local drivers="arygon,pn532_uart,pn532_spi,pn532_i2c,acr122s"
	drivers+=$(usev pcsc-lite ",acr122_pcsc,pcsc")
	drivers+=$(usev usb ",pn53x_usb,acr122_usb")
	econf \
		--with-drivers="${drivers}" \
		$(use_enable doc) \
		$(use_with readline)
}

src_compile() {
	default

	if use doc; then
		doxygen || die
		HTML_DOCS=( "${S}"/doc/html/. )
	fi
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	insinto /etc/nfc
	newins libnfc.conf.sample libnfc.conf
}
