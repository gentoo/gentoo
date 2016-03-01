# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=6.09
inherit perl-module

DESCRIPTION="Low-level HTTP connection (client)"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="minimal"

PATCHES=( "${FILESDIR}/networktest.patch" )
RDEPEND="
	!minimal? (
		>=dev-perl/IO-Socket-SSL-1.380.0
	)
	!<dev-perl/libwww-perl-6
	virtual/perl-Compress-Raw-Zlib
	virtual/perl-IO
	virtual/perl-IO-Compress
	dev-perl/URI
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
