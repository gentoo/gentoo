# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/JSON-PP/JSON-PP-2.272.20.ebuild,v 1.4 2015/06/06 19:42:24 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MAKAMAKA
MODULE_VERSION=2.27202
inherit perl-module

DESCRIPTION="JSON::XS compatible pure-Perl module"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="!!<dev-perl/JSON-2.50"

SRC_TEST="do"
