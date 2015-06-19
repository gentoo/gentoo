# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-FreeDB/Net-FreeDB-0.80.0-r1.ebuild,v 1.1 2014/08/23 02:11:11 axs Exp $

EAPI=5

MODULE_AUTHOR=ROAM
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="OOP interface to the FreeDB database"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-perl/CDDB-File-1.10.0
	virtual/perl-libnet
	>=virtual/perl-File-Temp-0.50.0
"
DEPEND="${RDEPEND}
"

SRC_TEST=online
