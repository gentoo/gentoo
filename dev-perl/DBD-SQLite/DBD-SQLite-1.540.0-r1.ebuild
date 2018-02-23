# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ISHIGAKI
DIST_VERSION=1.54
inherit perl-module

PATCH_TAG="${DIST_VERSION}-patches-1"

DESCRIPTION="Self Contained RDBMS in a DBI Driver"
SRC_URI="${SRC_URI}
	https://github.com/kentnl-gentoo/DBD-SQLite/releases/download/${PATCH_TAG}/${PN}-${PATCH_TAG}.tar.xz
	mirror://gentoo/${PN}-${PATCH_TAG}.tar.xz
	https://dev.gentoo.org/~kentnl/distfiles/${PN}-${PATCH_TAG}.tar.xz
"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="test system-sqlite"

# NB: Get min sqlite version from sqlite3.c
RDEPEND="
	system-sqlite? (
		>=dev-db/sqlite-3.13.0[extensions(+)]
		<dev-db/sqlite-3.21.0
	)
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

src_prepare() {
	eapply "${WORKDIR}/patches/"
	perl-module_src_prepare
	if use system-sqlite; then
		einfo "Removing bundled SQLite"
		# Flip Makefile into system mode.
		sed -i 's/^if ( 0 )/if ( 1 )/' "${S}"/Makefile.PL || die
		# remove bundled sqlite (rt.cpan#61361)
		for i in sqlite3{.c,.h,ext.h} ; do
			rm ${i} || die
			sed -i -e "/^${i}\$/d" MANIFEST || die
		done
		myconf="SQLITE_LOCATION=${EPREFIX}/usr"
	fi
}
