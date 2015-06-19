# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE-API-Peek/POE-API-Peek-2.200.0-r1.ebuild,v 1.1 2014/08/26 19:19:14 axs Exp $

EAPI=5

MODULE_AUTHOR=BINGOS
MODULE_VERSION=2.20
inherit perl-module

DESCRIPTION="Peek into the internals of a running POE env"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Devel-Size
	>=dev-perl/POE-1.311.0"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.31"

SRC_TEST=do
