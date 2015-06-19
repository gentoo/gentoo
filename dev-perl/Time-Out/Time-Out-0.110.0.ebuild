# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Time-Out/Time-Out-0.110.0.ebuild,v 1.1 2014/12/11 23:53:02 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=PATL
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Easily timeout long running operations"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
