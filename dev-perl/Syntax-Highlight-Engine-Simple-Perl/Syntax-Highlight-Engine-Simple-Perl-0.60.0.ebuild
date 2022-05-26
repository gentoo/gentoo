# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AKHUETTEL
DIST_VERSION=0.06

inherit perl-module

DESCRIPTION="Experimental Perl code highlighting class"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Syntax-Highlight-Engine-Simple-0.20.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PERL_RM_FILES=( "t/perlcritic.t" "t/perlcriticrc" "t/pod-coverage.t" "t/pod.t" )
