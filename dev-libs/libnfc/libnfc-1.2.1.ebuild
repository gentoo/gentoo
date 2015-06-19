# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libnfc/libnfc-1.2.1.ebuild,v 1.1 2009/08/16 14:18:29 ikelos Exp $

EAPI="2"

DESCRIPTION="Near Field Communications (NFC) library"
HOMEPAGE="http://www.libnfc.org/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="sys-apps/pcsc-lite
		virtual/libusb:0"
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install."
}
