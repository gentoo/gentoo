# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ALEXMV
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="A virtual browser that retries errors"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/libwww-perl"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
