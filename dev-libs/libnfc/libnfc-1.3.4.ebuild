# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libnfc/libnfc-1.3.4.ebuild,v 1.2 2011/03/20 18:11:44 ssuominen Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Near Field Communications (NFC) library"
HOMEPAGE="http://www.libnfc.org/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

CDEPEND="sys-apps/pcsc-lite
	virtual/libusb:0"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

src_compile() {
	emake || die "Failed to compile."
	use doc && doxygen
}

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install properly."
	use doc && dohtml "${S}"/doc/html/*
}
