# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=3.04
DIST_EXAMPLES=("eg/bench")
inherit perl-module

DESCRIPTION="JSON::XS - JSON serialising/deserialising, done correctly and fast"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~ppc-aix ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

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
