# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ETJ
DIST_VERSION=1.26
inherit perl-module

DESCRIPTION="Fast, generic event loop"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
IUSE="test"

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test )
"

mydoc="ANNOUNCE INSTALL TODO Tutorial.pdf Tutorial.pdf-errata.txt"
