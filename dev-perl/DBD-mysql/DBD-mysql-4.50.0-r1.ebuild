# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DVEEDEN
DIST_VERSION=4.050
inherit perl-module

DESCRIPTION="MySQL driver for the Perl5 Database Interface (DBI)"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

IUSE="mariadb +mysql test +ssl"
RESTRICT="!test? ( test )"
REQUIRED_USE="^^ ( mysql mariadb )"

DB_DEPENDS="
	mysql? ( dev-db/mysql-connector-c:= )
	mariadb? ( dev-db/mariadb-connector-c:=[ssl(+)?] )
"
RDEPEND="
	>=dev-perl/DBI-1.609.0
	>=dev-perl/Devel-CheckLib-1.109.0
	${DB_DEPENDS}
"
DEPEND="
	${DB_DEPENDS}
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Data-Dumper
	test? (
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.900.0
		virtual/perl-Time-HiRes
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-4.050-no-dot-inc.patch"
	"${FILESDIR}/${PN}-4.050-fix-float-type-conversion.patch"
	"${FILESDIR}/${PN}-4.050-fix-for-MariaDB-10.3.13-with-zerofil.patch"
)

PERL_RM_FILES=(
	t/pod.t
	t/manifest.t
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
	myconf="${myconf} --$(usex ssl ssl nossl) --mysql_config=${EPREFIX}/usr/bin/${impl}_config"
	perl-module_src_configure
}

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
src_test() {
	ewarn "Comprehensive testing requires additional manual steps. For details"
	ewarn "see:"
	ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}#Testing"

	einfo
	einfo "If tests fail, you have to configure your MySQL instance to create"
	einfo "and grant some privileges to the test user."
	einfo "You can run the following commands at the MySQL prompt: "
	einfo "> CREATE USER 'test'@'localhost' IDENTIFIED BY 'test';"
	einfo "> CREATE DATABASE test;"
	einfo "> GRANT ALL PRIVILEGES ON test.* TO 'test'@'localhost';"
	einfo
	sleep 5
	# Don't be a hero and try to do EXTENDED_TESTING=1 unless you can figure
	# out why 60leaks.t fails

	# Parallel testing is broken as 2 tests create the same table
	# and mysql isn't acid compliant and can't limit visibility of tables
	# to a transaction...
	DIST_TEST="do" perl-module_src_test
}
