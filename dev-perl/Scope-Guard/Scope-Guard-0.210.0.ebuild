# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHOCOLATE
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Lexically scoped resource management"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~mips ppc ~ppc64 ~s390 ~sparc x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
