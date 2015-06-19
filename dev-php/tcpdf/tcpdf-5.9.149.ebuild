# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/tcpdf/tcpdf-5.9.149.ebuild,v 1.2 2014/08/10 21:06:11 slyfox Exp $

EAPI=4

KEYWORDS="~amd64 ~x86"

MY_P=${PN}_${PV//./_}

DESCRIPTION="TCPDF is a FLOSS PHP class for generating PDF documents"
HOMEPAGE="http://www.tcpdf.org/"
SRC_URI="mirror://sourceforge/tcpdf/${MY_P}.zip"
LICENSE="LGPL-3"
SLOT="0"
IUSE="examples"

DEPEND="dev-lang/php"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	insinto "/usr/share/php/${PN}"
	doins *.php tcpdf.*
	doins -r config images fonts cache

	dodoc CHANGELOG.TXT README.TXT

	dohtml -r doc/*
	use examples && dodoc -r examples
}
