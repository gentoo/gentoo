# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Gearman/Gearman-1.120.0.ebuild,v 1.1 2015/06/21 19:04:02 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=1.12
inherit perl-module

DESCRIPTION="Gearman distributed job system, client and worker libraries"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-perl/string-crc32
	virtual/perl-Time-HiRes
"
RDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

mydoc="CHANGES HACKING TODO"
# testsuite requires gearman server
SRC_TEST="never"
