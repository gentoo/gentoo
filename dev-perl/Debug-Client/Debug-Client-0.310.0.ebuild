# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MANWAR
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="Client side code for perl debugger"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Carp-1.330.100
	>=virtual/perl-Exporter-5.700.0
	>=virtual/perl-IO-Socket-IP-0.290.0
	>=dev-perl/PadWalker-1.980.0
	>=virtual/perl-Term-ReadLine-1.140.0
	>=dev-perl/Term-ReadLine-Gnu-1.200.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=dev-perl/File-HomeDir-1.0.0
		>=virtual/perl-File-Temp-0.230.400
		>=virtual/perl-Scalar-List-Utils-1.380.0
		>=dev-perl/Test-CheckDeps-0.10.0
		>=dev-perl/Test-Class-0.420.0
		>=dev-perl/Test-Deep-0.112.0
		>=virtual/perl-Test-Simple-1.1.3
		>=dev-perl/Test-Requires-0.70.0
		>=virtual/perl-parent-0.228.0
		>=virtual/perl-version-0.990.800
		>=dev-perl/PadWalker-1.920.0
		>=dev-perl/Term-ReadLine-Perl-1.30.300
	)
"
