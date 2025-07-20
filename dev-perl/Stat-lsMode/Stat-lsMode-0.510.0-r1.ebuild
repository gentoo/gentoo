# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ARISTOTLE
DIST_VERSION=0.51
inherit perl-module

DESCRIPTION="Perl Stat-lsMode Module"

SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 sparc x86"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.57
"
