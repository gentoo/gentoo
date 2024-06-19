# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="WindowMaker Network Devices (dockapp)"
HOMEPAGE="https://www.thregr.org/~wavexx/software/wmnd/"
SRC_URI="https://www.thregr.org/~wavexx/software/wmnd/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="snmp"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm
	snmp? ( >=net-analyzer/net-snmp-5.2.1 )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
