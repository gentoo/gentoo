# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="A module for merging hierarchies using the C3 algorithm"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~ppc-aix ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Carp-0.10.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"
