# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HMBRAND
DIST_VERSION=1.651
DIST_A_EXT=tgz
DIST_EXAMPLES=("ex/*")
# bug #675164
DIST_TEST="do"
inherit perl-module

DESCRIPTION="Database independent interface for Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/PlRPC-0.200.0
	>=virtual/perl-Sys-Syslog-0.170.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"

PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod.t
)
