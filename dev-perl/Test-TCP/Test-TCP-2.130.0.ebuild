# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TOKUHIROM
MODULE_VERSION=2.13
inherit perl-module

DESCRIPTION="Testing TCP program"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="


	>=dev-perl/Test-SharedFork-0.190.0
	>=virtual/perl-IO-1.23
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-Time-HiRes
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		>=dev-perl/Test-SharedFork-0.290.0
		virtual/perl-File-Temp
		virtual/perl-Socket
	)
"

SRC_TEST="do parallel"
