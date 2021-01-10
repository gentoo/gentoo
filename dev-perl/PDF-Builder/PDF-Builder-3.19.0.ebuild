# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PMPERRY
DIST_VERSION=3.019
DIST_EXAMPLES=( "contrib/*" )
inherit perl-module

DESCRIPTION="Facilitates the creation and modification of PDF files"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Font-TTF
	virtual/perl-IO-Compress
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Memory-Cycle
	)
"

PERL_RM_FILES=( t/author-{critic,pod-syntax}.t )
