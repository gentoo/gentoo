# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DVEEDEN
DIST_VERSION=4.050
inherit eutils perl-module

DESCRIPTION="MySQL driver for the Perl5 Database Interface (DBI)"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="mariadb +mysql test +ssl"
RESTRICT="!test? ( test )"
REQUIRED_USE="^^ ( mysql mariadb )"

RDEPEND=">=dev-perl/DBI-1.609.0
	>=dev-perl/Devel-CheckLib-1.109.0
	mysql? ( dev-db/mysql-connector-c:= )
	mariadb? ( dev-db/mariadb-connector-c:=[ssl(+)?] )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Data-Dumper
	test? (
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.900.0
		virtual/perl-Time-HiRes
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-${DIST_VERSION}-no-dot-inc.patch"
	"${FILESDIR}/${PN}-${DIST_VERSION}-fix-float-type-conversion.patch"
	"${FILESDIR}/${PN}-${DIST_VERSION}-fix-for-MariaDB-10.3.13-with-zerofil.patch"
)

src_configure() {
	local impl
	impl=$(usex mariadb mariadb mysql)
	if use test; then
		myconf="${myconf} --testdb=test \
			--testhost=localhost \
			--testuser=test \
			--testpassword=test"
	fi
	myconf="${myconf} --$(usex ssl ssl nossl) --mysql_config=${EPREFIX%/}/usr/bin/${impl}_config"
	perl-module_src_configure
}

# Parallel testing is broken as 2 tests create the same table
# and mysql isn't acid compliant and can't limit visibility of tables
# to a transaction...
DIST_TEST="do"

src_test() {
	einfo
	einfo "If tests fail, you have to configure your MySQL instance to create"
	einfo "and grant some privileges to the test user."
	einfo "You can run the following commands at the MySQL prompt: "
	einfo "> CREATE USER 'test'@'localhost' IDENTIFIED BY 'test';"
	einfo "> CREATE DATABASE test;"
	einfo "> GRANT ALL PRIVILEGES ON test.* TO 'test'@'localhost';"
	einfo
	sleep 5
	perl_rm_files t/pod.t t/manifest.t
	# Don't be a hero and try to do EXTENDED_TESTING=1 unless you can figure
	# out why 60leaks.t fails
	perl-module_src_test
}
