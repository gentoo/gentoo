# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DOY
DIST_VERSION=0.30
inherit perl-module

DESCRIPTION="Visitor style traversal of Perl data structures"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Class-Load-0.60.0
	>=dev-perl/Moose-0.890.0
	>=dev-perl/Tie-ToObject-0.10.0
	>=dev-perl/namespace-clean-0.190.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
	)
"
