# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=0.111
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
	dev-perl/Statistics-CaseResampling
	virtual/perl-Time-HiRes
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? (
		>=virtual/perl-Test-Simple-0.940.0
	)
"
