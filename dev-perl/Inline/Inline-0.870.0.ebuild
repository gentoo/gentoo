# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=INGY
DIST_VERSION=0.87
inherit perl-module

DESCRIPTION="Write Perl subroutines in other languages"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=virtual/perl-File-Spec-0.800.0
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-Warn-0.230.0
	)
"
