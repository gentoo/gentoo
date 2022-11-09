# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="a try/catch/finally syntax for Perl"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="dev-perl/XS-Parse-Keyword"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	dev-perl/XS-Parse-Keyword
	virtual/perl-ExtUtils-CBuilder"
