# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ARP scanning and fingerprinting tool"
HOMEPAGE="
	http://www.nta-monitor.com/tools-resources/security-tools/arp-scan
	https://github.com/royhills/arp-scan
"
SRC_URI="http://www.nta-monitor.com/files/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
	dev-lang/perl
"
