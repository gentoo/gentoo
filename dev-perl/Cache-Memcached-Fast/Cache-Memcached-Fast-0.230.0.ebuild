# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=KROKI
MODULE_VERSION=0.23
inherit perl-module

DESCRIPTION="Perl client for memcached, in C language"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

SRC_TEST="do"

MAKEOPTS="${MAKEOPTS} -j1"

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test?	( virtual/perl-Test-Simple )
"
