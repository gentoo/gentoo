# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CJM
DIST_VERSION=1.12
inherit perl-module

DESCRIPTION="Getopt::Mixed is used for parsing mixed options"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc sparc x86"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"
