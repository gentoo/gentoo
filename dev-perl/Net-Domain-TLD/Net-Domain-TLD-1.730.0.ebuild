# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ALEXP
MODULE_VERSION=1.73
inherit perl-module

DESCRIPTION="Current top level domain names including new ICANN additions and ccTLDs"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Pod )
"

SRC_TEST="do"
