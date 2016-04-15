# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=1.12
inherit perl-module

DESCRIPTION="Gearman distributed job system, client and worker libraries"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-perl/String-CRC32
	virtual/perl-Time-HiRes
"
RDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

mydoc="CHANGES HACKING TODO"
# testsuite requires gearman server
SRC_TEST="never"
