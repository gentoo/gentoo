# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=INGY
DIST_VERSION=0.89
inherit perl-module

DESCRIPTION="A Data Driven Testing Framework"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	dev-perl/Filter
	>=virtual/perl-Scalar-List-Utils-1.70.0
	>=dev-perl/Spiffy-0.400.0
	>=virtual/perl-Test-Simple-0.880.0
	dev-perl/Test-Deep
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Algorithm-Diff-1.150.0
		>=virtual/perl-ExtUtils-MakeMaker-6.520.0
		>=dev-perl/Text-Diff-0.350.0
	)
"
