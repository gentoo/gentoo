# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=YANICK
DIST_VERSION=0.20
inherit perl-module

DESCRIPTION="Utility methods and base class for manipulating Perl via PPI"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-XSAccessor-1.20.0
	virtual/perl-File-Spec
	>=dev-perl/PPI-1.215.0
	dev-perl/Try-Tiny
"
DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		${RDEPEND}
		virtual/perl-File-Temp
		virtual/perl-IO
		>=dev-perl/Test-Differences-0.480.100
		dev-perl/Test-Exception
		dev-perl/Test-Most
		virtual/perl-Test-Simple
	)
"
PATCHES=("${FILESDIR}/${PN}-0.20-fix-pseudo-deps.patch")
