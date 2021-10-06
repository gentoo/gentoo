# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PCIMPRICH
DIST_VERSION=1.33
inherit perl-module

DESCRIPTION="Perl SAX 2 XS extension to Expat parser"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	dev-libs/expat
	>=dev-perl/XML-SAX-0.960.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test
		virtual/perl-Test-Harness )
"
