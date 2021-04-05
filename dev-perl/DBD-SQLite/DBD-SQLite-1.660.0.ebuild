# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ISHIGAKI
DIST_VERSION=1.66
inherit perl-module

DESCRIPTION="Self Contained RDBMS in a DBI Driver"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="test system-sqlite"
RESTRICT="!test? ( test )"

# Please read https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/DBD-SQLite
# when bumping versions re: system-sqlite interop
SYSTEM_SQLITE_DEP="
	>=dev-db/sqlite-3.32.3[extensions(+)]
"
RDEPEND="
	system-sqlite? ( ${SYSTEM_SQLITE_DEP} )
	>=dev-perl/DBI-1.570.0
	!<dev-perl/DBD-SQLite-1
	virtual/perl-Scalar-List-Utils
"
DEPEND="
	system-sqlite? ( ${SYSTEM_SQLITE_DEP} )
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	test? (
		>=virtual/perl-File-Spec-0.820.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"

src_prepare() {
	perl-module_src_prepare
	if use system-sqlite; then
		einfo "Removing bundled SQLite"
		eapply "${FILESDIR}/${PN}-1.64-no-bundle.patch"
		# remove bundled sqlite (rt.cpan#61361)
		perl_rm_files sqlite3{.c,.h,ext.h}
	fi
}
src_configure() {
	use system-sqlite && myconf="SQLITE_LOCATION=${EPREFIX}/usr"
	perl-module_src_configure
}

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
