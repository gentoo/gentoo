# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=EXODIST
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="fork test"

SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc x86"
IUSE="test"

RDEPEND="
	virtual/perl-File-Temp
	>=virtual/perl-Test-Simple-0.880.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-Test-Harness
		dev-perl/Test-Requires
		virtual/perl-Time-HiRes
	)
"
