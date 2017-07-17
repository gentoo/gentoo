# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BIOPERL_RELEASE=1.6.9

DIST_NAME=BioPerl-DB
DIST_AUTHOR=CJFIELDS
DIST_VERSION=1.006900
inherit perl-module

DESCRIPTION="Perl tools for bioinformatics - Perl API that accesses the BioSQL schema"
HOMEPAGE="http://www.bioperl.org/"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DIST_TEST="do" # Parallelism probably bad

RDEPEND="
	>=sci-biology/bioperl-${PV}
	dev-perl/DBD-mysql
	dev-perl/DBI
	sci-biology/biosql"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Data-Stag
		dev-perl/Sub-Uplevel
		dev-perl/Test-Warn
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"

src_prepare() {
	if use test; then
		eapply "${FILESDIR}/${PN}-1.6.9-db.patch"
		einfo "Using the following configuration details for test database:"
		einfo "  GENTOO_DB_TEST_HOST     : ${GENTOO_DB_TEST_HOST:=localhost}"
		einfo "  GENTOO_DB_TEST_USER     : ${GENTOO_DB_TEST_USER:=portage}"
		einfo "  GENTOO_DB_TEST_PORT     : ${GENTOO_DB_TEST_PORT:=3306}"
		einfo "  GENTOO_DB_TEST_PASSWOWRD: ${GENTOO_DB_TEST_PASSWORD:=sekrit}"
		einfo "  GENTOO_DB_TEST_DATABASE : ${GENTOO_DB_TEST_DB:=biosql_test}"
		einfo "Please ensure the relevant mysql database is configured and/or tweak"
		einfo "environment variables to suit"
		export GENTOO_DB_TEST_HOST GENTOO_DB_TEST_USER GENTOO_DB_TEST_PORT GENTOO_DB_TEST_PASSWORD GENTOO_DB_TEST_DB
	fi
	perl-module_src_prepare
}
src_install() {
	mydoc="AUTHORS BUGS FAQ"
	perl-module_src_install
}
src_test() {
	einfo "Removing bundled test libraries t/lib"
	rm -r "${S}/t/lib" || die "Cannot remove t/lib"
	perl-module_src_test
}
