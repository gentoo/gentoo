# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DCANTRELL
DIST_VERSION=0.0015
inherit perl-module

DESCRIPTION="Forces the unavailability of specified Perl modules (for testing)"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	virtual/perl-File-Temp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.820.0
	)
"

PERL_RM_FILES=(
	t/090pod.t
	t/098pod-coverage.t
)
