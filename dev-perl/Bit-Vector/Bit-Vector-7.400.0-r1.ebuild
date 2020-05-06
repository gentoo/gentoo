# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=STBEY
DIST_VERSION=7.4
inherit perl-module

DESCRIPTION="Efficient bit vector, set of integers and big int math library"
# License note: upstream mess, bug #721222
LICENSE="|| ( Artistic ( GPL-1 GPL-1+ ) ) LGPL-2 LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	>=dev-perl/Carp-Clan-5.300.0
	>=virtual/perl-Storable-2.210.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
