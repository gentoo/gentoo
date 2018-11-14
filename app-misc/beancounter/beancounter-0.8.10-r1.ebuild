# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Finance performance calculation engine with full data acquisition, SQL support"
HOMEPAGE="http://dirk.eddelbuettel.com/code/beancounter.html"
SRC_URI="http://eddelbuettel.com/dirk/code/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mysql postgres sqlite"

DEPEND="dev-perl/Date-Manip
	dev-perl/Statistics-Descriptive
	dev-perl/Finance-YahooQuote
	dev-perl/libwww-perl
	mysql? ( dev-perl/DBD-mysql )
	sqlite? ( dev-perl/DBD-SQLite )
	postgres? ( dev-perl/DBD-Pg )"

RDEPEND="${DEPEND} dev-perl/DBI"
mydoc="README example.beancounterrc beancounter_*.txt "

src_install() {
	perl-module_src_install
	# rm unwanted READMEs
	rm "${D}"usr/share/doc/${PF}/{README.Debian,README.non-gnu} || die
}
