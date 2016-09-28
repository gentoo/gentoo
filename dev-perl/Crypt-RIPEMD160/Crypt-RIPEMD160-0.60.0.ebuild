# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=TODDR
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl extension for the RIPEMD-160 Hash function"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

export OPTIMIZE="$CFLAGS"

RDEPEND=""
DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )"
