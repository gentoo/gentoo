# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=1.000014
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Read MaxMind DB files and look up IP addresses"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Data-IEEE754
	dev-perl/Data-Printer
	>=dev-perl/Data-Validate-IP-0.250.0
	dev-perl/DateTime
	virtual/perl-Encode
	virtual/perl-Getopt-Long
	dev-perl/List-AllUtils
	virtual/perl-Math-BigInt
	>=dev-perl/MaxMind-DB-Common-0.40.1
	dev-perl/Module-Implementation
	>=dev-perl/Moo-1.3.0
	dev-perl/MooX-StrictConstructor
	>=dev-perl/Role-Tiny-1.3.2
	>=virtual/perl-Socket-1.870.0
	virtual/perl-autodie
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-File-Spec
		>=dev-perl/Path-Class-0.270.0
		>=virtual/perl-Scalar-List-Utils-1.420.0
		dev-perl/Test-Bits
		dev-perl/Test-Fatal
		dev-perl/Test-Number-Delta
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.960.0
	)
"
