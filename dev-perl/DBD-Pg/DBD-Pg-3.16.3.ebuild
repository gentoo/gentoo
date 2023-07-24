# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TURNSTEP
inherit perl-module

DESCRIPTION="PostgreSQL database driver for the DBI module"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-version
	>=dev-perl/DBI-1.614.0
	dev-db/postgresql:*
"
DEPEND="
	dev-db/postgresql:*
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.580.0
	test? (
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-Time-HiRes
	)
"

PERL_RM_FILES=(
	"t/00_signature.t"
)

src_prepare() {
	postgres_include="$(readlink -f "${EPREFIX}"/usr/include/postgresql)"
	postgres_lib="${postgres_include//include/lib}"
	# Fall-through case is the non-split postgresql
	# The active cases instead get us the matching libdir for the includedir.
	for i in lib lib64 ; do
		if [ -d "${postgres_lib}/${i}" ]; then
			postgres_lib="${postgres_lib}/${i}"
			break
		fi
	done

	# env variables for compilation:
	export POSTGRES_INCLUDE="${postgres_include}"
	export POSTGRES_LIB="${postgres_lib}"
	perl-module_src_prepare
}

src_test() {
	local MODULES=(
		"Bundle::DBD::Pg v${PV}"
		"DBD::Pg v${PV}"
	)
	local failed=()

	local dep
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1 #||
			#die "Could not load ${dep}"
		eend $? || failed+=( "$dep" )
	done

	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi

	local LIVEDB_TESTS=(
		"t/01connect.t"
		"t/02attribs.t"
		"t/03dbmethod.t"
		"t/03smethod.t"
		"t/04misc.t"
		"t/06bytea.t"
		"t/07copy.t"
		"t/08async.t"
		"t/09arrays.t"
		"t/12placeholders.t"
		"t/20savepoints.t"
		"t/30unicode.t"
	)
	if [[ ! -v DBI_DSN ]]; then
		ewarn "Functional database tests disabled due to lack of configuration."
		ewarn "Please set the following environment variables values pertaining to a"
		ewarn "pre-configured Postgres installation in order for tests to work:"
		ewarn "  DBI_DSN  - A DBI-compatible connection string for a Postgres Database"
		ewarn "             ( eg: dbi:Pg:dbname=testdb )"
		ewarn "  DBI_USER - A Postgres Database Username"
		ewarn "  DBI_PASS - A Postgres Database Password"
		ewarn ""
		ewarn "For details, visit:"
		ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/DBD-Pg"
		perl_rm_files "${LIVEDB_TESTS[@]}"
	fi

	# Parallel testing breaks database access
	DBDPG_TEST_ALWAYS_ENV=1 DIST_TEST="do" perl-module_src_test
}
