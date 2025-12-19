# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="A try/catch/finally syntax for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="dev-perl/XS-Parse-Keyword"
BDEPEND="
	${RDEPEND}
	dev-perl/Module-Build
	>=dev-perl/XS-Parse-Keyword-0.350.0
"
