# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GUGOD
DIST_VERSION=0.36
inherit perl-module

DESCRIPTION="provides '\$self' in OO code"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/B-Hooks-Parser-0.210.0
	>=dev-perl/B-OPCheck-0.270.0
	>=dev-perl/PadWalker-1.930.0
	dev-perl/Sub-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=dev-perl/Test2-Suite-0.0.139 )
"
