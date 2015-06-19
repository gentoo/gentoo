# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Domain-TLD/Net-Domain-TLD-1.730.0.ebuild,v 1.1 2015/04/01 22:44:43 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ALEXP
MODULE_VERSION=1.73
inherit perl-module

DESCRIPTION="Current list of available top level domain names including new ICANN additions and ccTLDs"

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
