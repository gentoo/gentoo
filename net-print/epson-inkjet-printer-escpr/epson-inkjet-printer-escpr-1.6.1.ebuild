# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R)"
HOMEPAGE="http://www.epson.com/"
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/04/23/02/a5ee7e1622b0ba692bea6763d6d7f4810a8d0808/epson-inkjet-printer-escpr-1.6.1-1lsb3.2.tar.gz"
# http://download.ebz.epson.net/dsc/search/01/search/

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/1.6.1-warnings.patch"
}

src_configure() {
	econf --disable-shared

	# Makefile calls ls to generate a file list which is included in Makefile.am
	# Set the collation to C to avoid automake being called automatically
	unset LC_ALL
	export LC_COLLATE=C
}

src_install() {
	default
	rm -r "${ED%/}/usr/$(get_libdir)" || die
}
