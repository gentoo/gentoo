# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MATTLAW
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Utilities for handling Byte Order Marks"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Encode-1.990.0
	>=dev-perl/Readonly-0.60.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		>=dev-perl/Test-Exception-0.200.0
		virtual/perl-Test-Simple
	)
"

DIST_TEST=do
