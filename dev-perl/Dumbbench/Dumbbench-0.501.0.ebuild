# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BDFOY
DIST_VERSION=0.501
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="More reliable benchmarking with the least amount of thinking"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Capture-Tiny
	virtual/perl-Carp
	>=dev-perl/Class-XSAccessor-1.50.0
	dev-perl/Devel-CheckOS
	>=dev-perl/Number-WithError-1.0.0
	dev-perl/Params-Util
	>=dev-perl/Statistics-CaseResampling-0.60.0
	virtual/perl-Time-HiRes
	virtual/perl-parent
"

BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? (
		>=virtual/perl-Test-Simple-1.0.0
	)
"
