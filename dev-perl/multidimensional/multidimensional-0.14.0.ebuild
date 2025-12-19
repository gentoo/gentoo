# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ILMARI
DIST_VERSION=0.014
inherit perl-module

DESCRIPTION="disables multidimensional array emulation"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/B-Hooks-OP-Check-0.190.0
	virtual/perl-XSLoader
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/ExtUtils-Depends
	test? (
		>=virtual/perl-CPAN-Meta-2.112.580
		>=virtual/perl-Test-Simple-0.880.0
	)
"
