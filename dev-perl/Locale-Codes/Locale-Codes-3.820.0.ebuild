# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SBECK
DIST_VERSION=3.82
inherit perl-module

DESCRIPTION="Distribution of Perl modules to handle locale codes"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=dev-perl/Test-Inter-1.90.0
	)
"
