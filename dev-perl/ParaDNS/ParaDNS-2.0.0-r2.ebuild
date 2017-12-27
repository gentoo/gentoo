# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSERGEANT
DIST_VERSION=2.0
inherit perl-module

DESCRIPTION="a DNS lookup class for the Danga::Socket framework"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Net-DNS
	>=dev-perl/Danga-Socket-1.61"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0-net-dns-compat.patch"
	"${FILESDIR}/${PN}-2.0-no-network.patch"
)
