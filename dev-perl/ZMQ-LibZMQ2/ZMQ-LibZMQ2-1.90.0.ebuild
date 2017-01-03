# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DMAKI
DIST_VERSION=1.09
inherit perl-module

DESCRIPTION="A libzmq 2.x wrapper for Perl"

SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
IUSE="test"

RDEPEND="
	=net-libs/zeromq-2*
	dev-perl/Task-Weaken
	>=dev-perl/ZMQ-Constants-1.0.0
	>=virtual/perl-XSLoader-0.20.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	virtual/pkgconfig
	>=virtual/perl-Devel-PPPort-3.190.0
	>=virtual/perl-ExtUtils-ParseXS-3.180.0
	test? (
		dev-perl/Test-Requires
		dev-perl/Test-Fatal
		>=dev-perl/Test-TCP-1.80.0
		>=virtual/perl-Test-Simple-0.980.0
	)
"
