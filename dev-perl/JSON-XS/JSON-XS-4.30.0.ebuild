# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MLEHMANN
DIST_VERSION=4.03
DIST_EXAMPLES=("eg/bench")
inherit perl-module

DESCRIPTION="JSON::XS - JSON serialising/deserialising, done correctly and fast"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	dev-perl/Types-Serialiser
	dev-perl/common-sense
	!<dev-perl/JSON-2.900.0
	!<dev-perl/JSON-Any-1.310.0
"
BDEPEND="${RDEPEND}
	dev-perl/Canary-Stability
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
"
