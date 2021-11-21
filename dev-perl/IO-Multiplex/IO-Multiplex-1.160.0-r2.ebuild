# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BBB
DIST_VERSION=1.16
inherit perl-module

DESCRIPTION="Manage IO on many file handles"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"

RDEPEND="
	virtual/perl-IO
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
