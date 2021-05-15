# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CLKAO
DIST_VERSION=0.34
inherit perl-module

DESCRIPTION="Handle data in a hierarchical structure"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~mips ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-perl/Test-Exception
	)
"
