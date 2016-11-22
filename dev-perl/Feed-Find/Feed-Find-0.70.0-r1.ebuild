# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BTROTT
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Syndication feed auto-discovery"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Class-ErrorHandler
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/URI
"
DEPEND="${RDEPEND}"

SRC_TEST=online
