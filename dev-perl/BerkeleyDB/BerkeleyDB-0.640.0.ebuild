# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PMQS
DIST_VERSION=0.64
inherit perl-module db-use multilib

DESCRIPTION="This module provides Berkeley DB interface for Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# Install DB_File if you want older support. BerkleyDB no longer
# supports less than 2.0.

RDEPEND="
	>=sys-libs/db-2.0:=
	<sys-libs/db-7:=
"
DEPEND="
	>=sys-libs/db-2.0:=
	<sys-libs/db-7:=
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

PERL_RM_FILES=(
	"t/meta-json.t"
	"t/meta-yaml.t"
	"t/pod.t"
	"scan.pl"
	"mkconsts.pl"
)
# parallel really broken
DIST_TEST="do"
src_prepare() {
	local DB_SUPPORTED=(
		6 5 4 3 2
	)
	# on Gentoo/FreeBSD we cannot trust on the symlink /usr/include/db.h
	# as for Gentoo/Linux, so we need to esplicitely declare the exact berkdb
	# include path
	local dbdir="$(db_includedir "${DB_SUPPORTED[@]}" )"
	local dbname="$(db_libname "${DB_SUPPORTED[@]}" )"
	einfo "DB Include Dir: ${dbdir}"
	einfo "DB library: ${dbname}"

	rm -f "${S}/config.in" || die "Can't remove packaged config.in"

	printf "INCLUDE = %s\nLIB = %s\nDBNAME = -l%s\n" \
		"${dbdir}" \
		"${EPREFIX}/usr/$(get_libdir)" \
		"${dbname}" > "${S}"/config.in || die "Can't write config.in"

	perl-module_src_prepare
}
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
