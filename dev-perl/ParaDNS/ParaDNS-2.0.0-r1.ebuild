# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ParaDNS/ParaDNS-2.0.0-r1.ebuild,v 1.1 2014/08/26 18:04:20 axs Exp $

EAPI=5

MODULE_AUTHOR=MSERGEANT
MODULE_VERSION=2.0
inherit perl-module

DESCRIPTION="a DNS lookup class for the Danga::Socket framework"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Net-DNS
	>=dev-perl/Danga-Socket-1.61"
RDEPEND="${DEPEND}"

SRC_TEST=online
