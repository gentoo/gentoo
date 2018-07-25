# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BINGOS
DIST_VERSION=3.56
inherit perl-module

DESCRIPTION="Mapping Perl releases on CPAN to the location of the tarballs"
SLOT="0"
KEYWORDS="amd64 x86"
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
PERL_RM_FILES=( "t/author-pod-coverage.t" "t/author-pod-syntax.t" )
