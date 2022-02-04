# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CFRANKS
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Open a browser at a given URL"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.920.0
	)
"
