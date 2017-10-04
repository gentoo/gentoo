# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GRANTG
DIST_VERSION=1.08
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A clone of the classic Eliza program"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
