# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.150
inherit perl-module

DESCRIPTION="File path utility"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	!minimal? (
		>=dev-perl/Unicode-UTF8-0.580.0
	)
"
BDEPEND="
	${RDEPEND}
	test? (
		!minimal? (
			dev-perl/Test-FailWarnings
			dev-perl/Test-MockRandom
		)
	)
"
