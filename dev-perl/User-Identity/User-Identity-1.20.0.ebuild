# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=1.02
inherit perl-module

DESCRIPTION="Maintains info about a physical person"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc64 ~riscv x86"

# dev-perl/TimeDate
# dev-perl/Geography-Countries
RDEPEND="
	!<dev-perl/Geography-Countries-1.400.0
	>=dev-perl/Hash-Ordered-0.14.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
