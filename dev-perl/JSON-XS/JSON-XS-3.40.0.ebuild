# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=3.04
DIST_EXAMPLES=("eg/bench")
inherit perl-module

DESCRIPTION="JSON::XS - JSON serialising/deserialising, done correctly and fast"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Types-Serialiser
	dev-perl/common-sense
	!<dev-perl/JSON-2.900.0
	!<dev-perl/JSON-Any-1.310.0
"
DEPEND="${RDEPEND}
	dev-perl/Canary-Stability
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	test? ( virtual/perl-Test-Harness )"
