# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=1.28
inherit perl-module

DESCRIPTION="Fast, generic event loop"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ppc64 sparc x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-1.0.0
	)
"

mydoc="ANNOUNCE INSTALL TODO Tutorial.pdf Tutorial.pdf-errata.txt"
