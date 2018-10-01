# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BBB
DIST_VERSION=1.16
inherit perl-module

DESCRIPTION="Manage IO on many file handles"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~mips ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="virtual/perl-IO"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
