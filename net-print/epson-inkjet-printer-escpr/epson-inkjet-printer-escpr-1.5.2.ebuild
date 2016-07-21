# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R)"
HOMEPAGE="http://www.epson.com/"
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/04/11/66/a0e858032ab0fd6a32c7fb3b7e447a0229e79141/epson-inkjet-printer-escpr-1.5.2-1lsb3.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/1.5.2-warnings.patch"
}

src_configure() {
	econf --disable-shared
}

src_install() {
	default
	rm -r "${ED%/}/usr/$(get_libdir)" || die
}
