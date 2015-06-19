# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/IO-Socket-IP/IO-Socket-IP-0.280.0.ebuild,v 1.3 2015/06/13 19:39:17 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=PEVANS
MODULE_VERSION=0.28
inherit perl-module

DESCRIPTION='A drop-in replacement for IO::Socket::INET supporting both IPv4 and IPv6'

SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	>=virtual/perl-Socket-1.970.0
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
	)
"

SRC_TEST="do"
