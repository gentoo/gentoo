# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.77
inherit perl-module

DESCRIPTION="Fast CGI module"

LICENSE="FastCGI"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 x86"
IUSE=""

RDEPEND="
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
