# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Find the differences between two arrays"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/Algorithm-Diff-1.190.0
	dev-perl/Class-Accessor
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
