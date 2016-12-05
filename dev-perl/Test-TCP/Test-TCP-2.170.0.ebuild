# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SYOHEX
DIST_VERSION=2.17
inherit perl-module

DESCRIPTION="Testing TCP program"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-IO
	virtual/perl-IO-Socket-IP
	>=dev-perl/Test-SharedFork-0.290.0
	virtual/perl-Test-Simple
	>=virtual/perl-IO-1.230.0
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		virtual/perl-File-Temp
		virtual/perl-Socket
	)
"
