# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
