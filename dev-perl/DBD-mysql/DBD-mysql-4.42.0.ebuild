# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MICHIELB
DIST_VERSION=4.042
inherit eutils perl-module

DESCRIPTION="MySQL driver for the Perl5 Database Interface (DBI)"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~s390 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

# embedded=on disables ssl support
# https://metacpan.org/source/MICHIELB/DBD-mysql-4.036/dbdimp.c#L1886
REQUIRED_USE="?? ( embedded ssl )"
IUSE="embedded test +ssl"

RDEPEND=">=dev-perl/DBI-1.609.0
	<dev-db/mysql-connector-c-8.0:0=
	embedded? ( virtual/mysql[embedded] )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Data-Dumper
	dev-perl/Devel-CheckLib
	test? (
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.900.0
		virtual/perl-Time-HiRes
	)
"
PATCHES=( "${FILESDIR}/${DIST_VERSION}-no-dot-inc.patch" )
src_configure() {
	if use test; then
		myconf="${myconf} --testdb=test \
			--testhost=localhost \
			--testuser=test \
			--testpassword=test"
	fi
	myconf="${myconf} --$(usex ssl ssl nossl)"
	use embedded && myconf="${myconf} --force-embedded --embedded=mysql_config"
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
