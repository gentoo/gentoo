# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.005
inherit perl-module

DESCRIPTION="produce tied (and other) separate but combined variables"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
