# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HMBRAND
DIST_VERSION=1.645
DIST_A_EXT=tgz
DIST_EXAMPLES=("ex/*")
inherit perl-module

DESCRIPTION="Database independent interface for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/PlRPC-0.200.0
	>=virtual/perl-Sys-Syslog-0.170.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Scalar-List-Utils
	!<=dev-perl/SQL-Statement-1.330.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	test? (
		>=virtual/perl-Test-Simple-0.900.0
	)
"
PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod.t
)
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

src_test() {
	if [[ $(makeopts_jobs) -gt 70 ]]; then
		einfo "Reducing jobs to 70. Bug: https://bugs.gentoo.org/675164"
		MAKEOPTS="${MAKEOPTS} -j70";
	fi
	perl-module_src_test
}
