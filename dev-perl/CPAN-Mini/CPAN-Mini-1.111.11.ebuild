# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.111011
inherit perl-module

DESCRIPTION="Create a minimal mirror of CPAN"

SLOT="0"
KEYWORDS="amd64 x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	dev-perl/libwww-perl
	>=virtual/perl-IO-Compress-1.20
	dev-perl/File-HomeDir
	>=virtual/perl-File-Path-2.08
	dev-perl/URI
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.96
	)
"

SRC_TEST="do"
