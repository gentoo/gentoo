# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MSCHOUT
MODULE_VERSION=3.23
inherit perl-module

DESCRIPTION="Perl Authentication and Authorization via cookies"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=www-apache/mod_perl-2
	>=dev-perl/CGI-3.120.0
	>=dev-perl/Class-Load-0.30.0
	>=dev-perl/autobox-1.100.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=dev-perl/Apache-Test-1.390.0 )
"

SRC_TEST="do parallel"
