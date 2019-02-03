# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=AKHUETTEL
DIST_VERSION=0.05

inherit perl-module

DESCRIPTION="Experimental Perl code highlighting class"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Syntax-Highlight-Engine-Simple-0.20.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PATCHES=( "${FILESDIR}/${PN}-0.05-noreadme.patch" )
PERL_RM_FILES=( "t/perlcritic.t" "t/perlcriticrc" "t/pod-coverage.t" "t/pod.t" )
