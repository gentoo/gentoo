# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DIST_VERSION=1.03
DIST_AUTHOR=DRTECH
inherit perl-module

DESCRIPTION="XSS filter using HTML::Parser"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="test"

RDEPEND="
	>=dev-perl/HTML-Parser-3.560.0
	>=dev-perl/HTML-StripScripts-1.50.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
