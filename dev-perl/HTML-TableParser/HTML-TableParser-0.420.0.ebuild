# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DJERIUS
DIST_VERSION=0.42
inherit perl-module

DESCRIPTION="Extract data from an HTML table"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-perl/HTML-Parser-3.260.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	virtual/perl-CPAN-Meta
	test? (
		>=virtual/perl-Test-Simple-0.320.0
	)
"
