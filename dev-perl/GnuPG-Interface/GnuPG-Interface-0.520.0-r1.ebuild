# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ALEXMV
MODULE_VERSION=0.52
inherit perl-module

DESCRIPTION="Perl module interface to interacting with GnuPG"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=app-crypt/gnupg-1.2.1-r1
	virtual/perl-autodie
	>=virtual/perl-Math-BigInt-1.780.0
	>=dev-perl/Moo-0.91.11
	>=dev-perl/MooX-HandlesVia-0.1.4
	>=dev-perl/MooX-late-0.14.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
"
SRC_TEST="do"
