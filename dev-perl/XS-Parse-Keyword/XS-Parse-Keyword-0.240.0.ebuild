# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.24
inherit perl-module

DESCRIPTION="XS functions to assist in parsing keyword syntax"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	dev-perl/ExtUtils-CChecker
	dev-perl/Module-Build
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-ParseXS"
