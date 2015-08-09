# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BTROTT
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="Smart URI fetching/caching"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Class-ErrorHandler
	virtual/perl-IO-Compress
	dev-perl/libwww-perl
	virtual/perl-Storable
	dev-perl/URI
"
DEPEND="${RDEPEND}"

SRC_TEST=online
