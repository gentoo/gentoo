# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SCHWIGON
MODULE_VERSION=2.24
SRC_URI="mirror://cpan/authors/id/S/SC/SCHWIGON/class-methodmaker/${PN}-${MODULE_VERSION}.tar.gz"
inherit perl-module eutils

DESCRIPTION="Create generic methods for OO Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
