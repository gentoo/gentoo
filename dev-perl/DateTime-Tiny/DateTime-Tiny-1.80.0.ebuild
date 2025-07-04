# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.08

inherit perl-module

DESCRIPTION="Date object, with as little code as possible"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
"
