# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PLICEASE
DIST_VERSION=1.17
inherit perl-module

DESCRIPTION="Perl-only 'which'"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/File-Which-1.140.0
"
# Test2::V0 -> Test2-Suite-0.0.72
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		dev-perl/Capture-Tiny
		>=virtual/perl-Test2-Suite-0.0.121
		>=dev-perl/Test-Script-1.90.0
	)
"
