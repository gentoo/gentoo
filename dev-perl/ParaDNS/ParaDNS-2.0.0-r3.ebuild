# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSERGEANT
DIST_VERSION=2.0
inherit perl-module

DESCRIPTION="a DNS lookup class for the Danga::Socket framework"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Net-DNS
	>=dev-perl/Danga-Socket-1.61
"
BDEPEND="${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0-net-dns-compat.patch"
	"${FILESDIR}/${PN}-2.0-no-network.patch"
)
