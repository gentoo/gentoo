# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Stock ticker, profit/loss calculator and chart tool"
HOMEPAGE="https://eddelbuettel.com/dirk/code/smtm.html"
SRC_URI="https://eddelbuettel.com/dirk/code/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

DEPEND="dev-perl/Tk
	dev-perl/Date-Manip
	dev-perl/HTML-Parser
	dev-perl/Finance-YahooQuote
	dev-perl/libwww-perl"

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
