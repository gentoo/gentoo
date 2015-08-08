# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_VERSION=1.01
MODULE_AUTHOR=TIMA
inherit perl-module

DESCRIPTION="Object-oriented interface for developing Trackback clients and servers"
IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64"

DEPEND=">=dev-perl/libwww-perl-5.831
	>=dev-perl/Class-ErrorHandler-0.01"
RDEPEND="${DEPEND}"
