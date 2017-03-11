# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ARISTOTLE
MODULE_VERSION=0.16
inherit perl-module

DESCRIPTION="Store multiple values per key"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
