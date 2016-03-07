# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=JROGERS
DIST_VERSION=3.04
inherit perl-module

DESCRIPTION="interact with TELNET port or other TCP ports in Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=">=virtual/perl-libnet-1.70.300"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
