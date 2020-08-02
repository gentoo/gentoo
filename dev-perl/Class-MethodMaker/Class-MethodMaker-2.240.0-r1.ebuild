# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SCHWIGON
DIST_VERSION=2.24
DIST_SECTION="class-methodmaker"
inherit perl-module eutils

DESCRIPTION="Create generic methods for OO Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
