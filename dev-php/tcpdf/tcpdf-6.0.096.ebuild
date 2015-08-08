# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KEYWORDS="~amd64 ~x86"

MY_P=${PN}_${PV//./_}

DESCRIPTION="TCPDF is a FLOSS PHP class for generating PDF documents"
HOMEPAGE="http://www.tcpdf.org/"
SRC_URI="mirror://sourceforge/tcpdf/${MY_P}.zip"
# Main source is LGPL-3+, some included fonts have other licenses
LICENSE="LGPL-3+ GPL-3 BitstreamVera GPL-2"
SLOT="0"
IUSE="examples"

RDEPEND="dev-lang/php"
DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_install() {
	insinto "/usr/share/php/${PN}"
	doins *.php tcpdf.*
	doins -r config include fonts tools

	dodoc CHANGELOG.TXT README.TXT

	use examples && dodoc -r examples
}
