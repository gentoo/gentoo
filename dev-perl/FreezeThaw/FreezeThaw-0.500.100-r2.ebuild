# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ILYAZ
DIST_SECTION=modules
DIST_VERSION=0.5001
inherit perl-module

DESCRIPTION="Convert Perl structures to strings and back"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
