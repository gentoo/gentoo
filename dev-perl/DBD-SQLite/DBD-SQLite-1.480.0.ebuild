# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ISHIGAKI
MODULE_VERSION=1.48
inherit perl-module

DESCRIPTION="Self Contained RDBMS in a DBI Driver"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-db/sqlite-3.6.22[extensions(+)]
	>=dev-perl/DBI-1.570.0
	!<dev-perl/DBD-SQLite-1
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	test? (
		>=virtual/perl-File-Spec-0.820.0
		>=virtual/perl-Test-Simple-0.420.0
	)
"

SRC_TEST="do"

src_prepare() {
	perl-module_src_prepare
	sed -i 's/^if ( 0 )/if ( 1 )/' "${S}"/Makefile.PL || die
	# remove bundled sqlite (rt.cpan#61361)
	for i in sqlite3{.c,.h,ext.h} ; do
		rm ${i} || die
		sed -i -e "/^${i}\$/d" MANIFEST || die
	done

	myconf="SQLITE_LOCATION=${EPREFIX}/usr"
}
