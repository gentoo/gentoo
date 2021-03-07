# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=INGY
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Testing Module for YAML Implementations"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Test-Base-0.860.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
# Presently no actual tests worth running
DIST_TEST=skip
