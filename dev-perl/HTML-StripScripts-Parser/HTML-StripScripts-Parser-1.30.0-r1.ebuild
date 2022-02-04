# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=1.03
DIST_AUTHOR=DRTECH
inherit perl-module

DESCRIPTION="XSS filter using HTML::Parser"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/HTML-Parser-3.560.0
	>=dev-perl/HTML-StripScripts-1.50.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
