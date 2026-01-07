# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=6.11
inherit perl-module

DESCRIPTION="Storage of cookies"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	!<dev-perl/libwww-perl-6
	virtual/perl-Carp
	>=dev-perl/HTTP-Date-6.0.0
	>=dev-perl/HTTP-Message-6.0.0
	virtual/perl-Time-Local
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/URI
	)
"
