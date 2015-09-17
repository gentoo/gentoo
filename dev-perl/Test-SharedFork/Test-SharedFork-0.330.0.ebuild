# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=EXODIST
MODULE_VERSION=0.33
inherit perl-module

DESCRIPTION="fork test"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-File-Temp
	>=virtual/perl-Test-Simple-0.880.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Harness
		virtual/perl-Test-Simple
		dev-perl/Test-Requires
		virtual/perl-Time-HiRes
	)
"

SRC_TEST="do parallel"
