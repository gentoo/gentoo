# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DOY
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Easy aliasing of methods and attributes in Moose"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"

RDEPEND="
	>=dev-perl/Moose-1.90.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.56
	test? (
		>=dev-perl/Test-Fatal-0.003
		>=virtual/perl-Test-Simple-0.88
		dev-perl/Test-Requires
	)
"
