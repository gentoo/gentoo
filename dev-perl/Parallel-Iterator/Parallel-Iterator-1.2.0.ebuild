# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ARISTOTLE
DIST_VERSION=1.002
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Simple parallel execution"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-IO
	virtual/perl-Storable
"
BDEPEND="
	${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"
