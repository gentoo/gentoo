# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=REHSACK
DIST_VERSION=1.414
inherit perl-module

DESCRIPTION="Small SQL parser and engine"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/Math-Base-Convert
		>=dev-perl/Text-Soundex-3.40.0
	)
	>=dev-perl/Clone-0.300.0
	dev-perl/Module-Runtime
	>=dev-perl/Params-Util-1.0.0
	>=virtual/perl-Scalar-List-Utils-1.0.0
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Math-Base-Convert
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.900.0
		>=dev-perl/Text-Soundex-3.40.0
	)
"
