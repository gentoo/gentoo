# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Firewall and Intrusion Detection System testing tool"
HOMEPAGE="http://dev.inversepath.com/trac/ftester"
SRC_URI="http://dev.inversepath.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	dev-perl/List-MoreUtils
	dev-perl/Net-Pcap
	dev-perl/Net-PcapUtils
	dev-perl/Net-RawIP
	dev-perl/NetPacket
"

src_install() {
	dodoc CREDITS Changelog ftest.conf
	doman ${PN}.8
	dosbin ftestd ftest freport
}
