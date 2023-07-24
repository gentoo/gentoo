# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PMPERRY
DIST_VERSION=3.025
DIST_EXAMPLES=( "contrib/*" "examples/*" )
inherit perl-module

DESCRIPTION="Facilitates the creation and modification of PDF files"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv x86"

RDEPEND="
	>=dev-perl/Font-TTF-1.40.0
	virtual/perl-IO-Compress
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.660.0
	test? (
		dev-perl/Test-Exception
		>=dev-perl/Test-Memory-Cycle-1.0.0
	)
"

PERL_RM_FILES=( t/author-{critic,pod-syntax}.t )
