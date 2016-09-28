# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RSAVAGE
DIST_VERSION=1.27
DIST_A_EXT=tgz
inherit perl-module

DESCRIPTION="A simple tree object"

SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="test minimal"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.180.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? ( dev-perl/Test-Memory-Cycle )
		>=dev-perl/Test-Exception-0.150.0
		>=virtual/perl-Test-Simple-1.1.14
	)
"
