# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

BIOPERL_RELEASE=1.6.9

MY_PN=BioPerl-DB
MODULE_AUTHOR=CJFIELDS
MODULE_VERSION=1.006900
inherit perl-module

DESCRIPTION="Perl tools for bioinformatics - Perl API that accesses the BioSQL schema"
HOMEPAGE="http://www.bioperl.org/"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="test"
SRC_TEST="do"

CDEPEND="
	>=sci-biology/bioperl-${PV}
	dev-perl/DBD-mysql
	dev-perl/DBI
	sci-biology/biosql"
DEPEND="${CDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Data-Stag
		dev-perl/Sub-Uplevel
		dev-perl/Test-Warn
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
RDEPEND="${CDEPEND}"

src_install() {
	mydoc="AUTHORS BUGS FAQ"
	perl-module_src_install
}
src_test() {
	einfo "Removing bundled test libraries t/lib"
	rm -r "${S}/t/lib" || die "Cannot remove t/lib"
	perl-module_src_test
}
