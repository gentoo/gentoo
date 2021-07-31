# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=YANICK
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Utility methods and base class for manipulating Perl via PPI"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-XSAccessor-1.20.0
	virtual/perl-File-Spec
	>=dev-perl/PPI-1.203.0
	dev-perl/Try-Tiny
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		virtual/perl-IO
		dev-perl/Test-Differences
		dev-perl/Test-Exception
		dev-perl/Test-Most
		virtual/perl-Test-Simple
	)
"
