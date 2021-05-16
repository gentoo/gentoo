# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Portuguese language stemming"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test )
"
