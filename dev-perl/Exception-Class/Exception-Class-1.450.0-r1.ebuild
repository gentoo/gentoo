# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.45
DIST_EXAMPLES=("bench/*")
inherit perl-module

DESCRIPTION="Module that allows you to declare real exception classes in Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/Class-Data-Inheritable-0.20.0
	>=dev-perl/Devel-StackTrace-2.0.0
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
