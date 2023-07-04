# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.34
inherit perl-module

DESCRIPTION="XS functions to assist in parsing keyword syntax"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND=""
BDEPEND="
	${RDEPEND}
	>=dev-perl/ExtUtils-CChecker-0.110.0
	>=dev-perl/Module-Build-0.400.400
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-ParseXS
	test? ( dev-perl/Test2-Suite )
"
