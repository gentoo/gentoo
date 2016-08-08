# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DJERIUS
MODULE_VERSION=0.40
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

SRC_TEST="do parallel"
