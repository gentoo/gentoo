# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=HAARG
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="A module for merging hierarchies using the C3 algorithm"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86 ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Carp-0.10.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"
