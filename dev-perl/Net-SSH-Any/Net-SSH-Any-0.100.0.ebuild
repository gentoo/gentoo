# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SALVA
DIST_VERSION=0.10
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Use any SSH module"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-1.302.26
	)
"
mydoc="docs/*"
