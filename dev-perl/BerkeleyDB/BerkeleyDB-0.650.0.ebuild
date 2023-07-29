# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PMQS
DIST_VERSION=0.65
# parallel really broken
DIST_TEST="do"
inherit perl-module db-use

DESCRIPTION="This module provides Berkeley DB interface for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv sparc x86"

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
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PERL_RM_FILES=(
	"t/meta-json.t"
	"t/meta-yaml.t"
	"t/pod.t"
	"scan.pl"
	"mkconsts.pl"
)

src_prepare() {
	local DB_SUPPORTED=(
		6 5 4 3 2
	)

	# on Gentoo Prefix, we cannot trust the symlink /usr/include/db.h
	# as for Gentoo/Linux, so we need to explicitly declare the exact berkdb
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
