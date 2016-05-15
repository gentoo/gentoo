# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=PCIMPRICH
DIST_VERSION=1.33
inherit perl-module

DESCRIPTION="Perl SAX 2 XS extension to Expat parser"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-libs/expat
	>=dev-perl/XML-SAX-0.960.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-ExtUtils-Command
		virtual/perl-Test
		virtual/perl-Test-Harness )"
