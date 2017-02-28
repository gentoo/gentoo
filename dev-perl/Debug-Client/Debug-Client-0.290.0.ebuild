# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BOWTIE
MODULE_VERSION=0.29
inherit perl-module

DESCRIPTION="Client side code for perl debugger"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-IO-Socket-IP-0.210.0
	>=dev-perl/PadWalker-1.960.0
	>=dev-perl/Term-ReadLine-Gnu-1.200.0
	>=virtual/perl-Term-ReadLine-1.100.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=dev-perl/File-HomeDir-1.0.0
		>=virtual/perl-File-Temp-0.230.100
		>=dev-perl/Test-CheckDeps-0.6.0
		>=dev-perl/Test-Class-0.390.0
		>=dev-perl/Test-Deep-0.110.0
		>=dev-perl/Test-Requires-0.70.0
		>=virtual/perl-File-Spec-3.400.0
		>=dev-perl/PadWalker-1.920.0
		>=dev-perl/Term-ReadLine-Perl-1.30.300
		>=virtual/perl-version-0.990.220
	)"

SRC_TEST=do
