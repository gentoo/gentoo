# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils

DESCRIPTION="Near Field Communications (NFC) library"
HOMEPAGE="http://www.libnfc.org/"
SRC_URI="https://github.com/nfc-tools/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sys-apps/pcsc-lite
	virtual/libusb:0"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_compile() {
	emake || die "Failed to compile."
	use doc && doxygen
}

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install properly."
	use doc && dohtml "${S}"/doc/html/*
}
