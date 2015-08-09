# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="WindowMaker Network Devices (dockapp)"
HOMEPAGE="http://www.thregr.org/~wavexx/software/wmnd/"
SRC_URI="http://www.thregr.org/~wavexx/software/wmnd/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="snmp"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm
	snmp? ( >=net-analyzer/net-snmp-5.2.1 )"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_install() {
	emake DESTDIR="${D}" install

	dodoc README AUTHORS ChangeLog NEWS TODO
}
