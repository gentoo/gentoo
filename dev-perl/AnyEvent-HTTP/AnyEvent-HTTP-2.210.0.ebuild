# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AnyEvent-HTTP/AnyEvent-HTTP-2.210.0.ebuild,v 1.1 2015/04/12 18:22:06 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=2.21
inherit perl-module

DESCRIPTION="Simple but non-blocking HTTP/HTTPS client"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/AnyEvent-5.330.0
	>=dev-perl/common-sense-3.300.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
