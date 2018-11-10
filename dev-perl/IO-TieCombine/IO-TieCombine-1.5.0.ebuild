# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=1.005
inherit perl-module

DESCRIPTION="produce tied (and other) separate but combined variables"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# r: Symbol, strict, warnings -> perl
RDEPEND="
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
