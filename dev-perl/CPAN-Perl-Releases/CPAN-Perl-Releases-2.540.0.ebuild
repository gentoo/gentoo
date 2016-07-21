# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=BINGOS
DIST_VERSION=2.54
inherit perl-module

DESCRIPTION='Mapping Perl releases on CPAN to the location of the tarballs'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.470.0
	)
"
