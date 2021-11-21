# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.002
inherit perl-module

DESCRIPTION="Designate tests only run by module authors"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Module-Install
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
