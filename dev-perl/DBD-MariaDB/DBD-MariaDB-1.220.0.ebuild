# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PALI
DIST_VERSION=1.22
inherit perl-module

DESCRIPTION="MariaDB and MySQL driver for the Perl5 Database Interface (DBI)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mariadb mysql minimal"
REQUIRED_USE="^^ ( mysql mariadb )"

RDEPEND="
	>=dev-perl/DBI-1.608.0
	virtual/perl-XSLoader
	mysql? ( dev-db/mysql-connector-c:= )
	mariadb? ( dev-db/mariadb-connector-c:= )
"
DEPEND="
	mysql? ( dev-db/mysql-connector-c:= )
	mariadb? ( dev-db/mariadb-connector-c:= )
"
# New test-harness needed for parallel testing to work
DEPEND="${RDEPEND}
	virtual/perl-Data-Dumper
	>=dev-perl/Devel-CheckLib-1.120.0
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	test? (
		!minimal? (
			>=dev-perl/Net-SSLeay-1.430.0
			dev-perl/Proc-ProcessTable
			virtual/perl-Storable
		)
		virtual/perl-Encode
		virtual/perl-File-Temp
		dev-perl/Test-Deep
		>=virtual/perl-Test-Harness-3.310.0
		>=virtual/perl-Test-Simple-0.900.0
		virtual/perl-Time-HiRes
		virtual/perl-bignum
	)
"

PERL_RM_FILES=(
	"t/pod.t"
	"t/manifest.t"
)

src_configure() {
	local impl=$(usex mariadb mariadb mysql)

	if use test; then
		myconf=(
			${myconf}
			--testdb=test
			--testhost=localhost
			--testuser=test
			--testpassword=test
		)
	fi

	myconf+=( --${impl}_config="${BROOT}"/usr/bin/${impl}_config )

	perl-module_src_configure
}

src_test() {
	ewarn "Comprehensive testing requires additional manual steps. For details"
	ewarn "see:"
	ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}#Testing"

	einfo
	einfo "If tests fail, you have to configure your MariaDB/MySQL instance"
	einfo "to create and grant some privileges to the test user."
	einfo "You can run the following commands at the MariaDB/MySQL prompt: "
	einfo "> CREATE USER 'test'@'localhost' IDENTIFIED BY 'test';"
	einfo "> CREATE DATABASE test;"
	einfo "> GRANT ALL PRIVILEGES ON test.* TO 'test'@'localhost';"
	einfo

	sleep 5

	# Don't be a hero and try to do EXTENDED_TESTING=1 unless you can figure
	# out why 60leaks.t fails
	perl-module_src_test
}
