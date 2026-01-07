# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GRANTM
DIST_VERSION=1.09
inherit perl-module

DESCRIPTION="Base class SAX Drivers and Filters"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	!<dev-perl/XML-SAX-0.990.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
