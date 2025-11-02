# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MAXMIND
DIST_VERSION=1.000014
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Read MaxMind DB files and look up IP addresses"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv x86"

RDEPEND="
	dev-perl/Data-IEEE754
	dev-perl/Data-Printer
	>=dev-perl/Data-Validate-IP-0.250.0
	dev-perl/DateTime
	dev-perl/List-AllUtils
	>=dev-perl/MaxMind-DB-Common-0.40.1
	dev-perl/Module-Implementation
	>=dev-perl/Moo-1.3.0
	dev-perl/MooX-StrictConstructor
	>=dev-perl/Role-Tiny-1.3.2
	>=virtual/perl-Socket-1.870.0
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/Path-Class-0.270.0
		>=virtual/perl-Scalar-List-Utils-1.420.0
		dev-perl/Test-Bits
		dev-perl/Test-Fatal
		dev-perl/Test-Number-Delta
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.960.0
	)
"
