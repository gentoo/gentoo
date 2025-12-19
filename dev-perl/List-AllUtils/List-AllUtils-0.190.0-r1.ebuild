# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="Combines many List::* utility modules in one bite-sized package"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
LICENSE="Artistic-2"

RDEPEND="
	>=dev-perl/List-SomeUtils-0.580.0
	>=virtual/perl-Scalar-List-Utils-1.560.0
	>=dev-perl/List-UtilsBy-0.110.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
