# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=2.00

inherit perl-module

DESCRIPTION="Check the correct line endings in your project"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=virtual/perl-JSON-PP-2.273.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Temp
	)
"
