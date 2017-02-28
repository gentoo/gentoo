# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools fcaps git-r3

DESCRIPTION="ARP Ping"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=arping"
EGIT_REPO_URI="https://github.com/ThomasHabets/arping"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS=""

CDEPEND="
	net-libs/libpcap
	net-libs/libnet:1.1
"
DEPEND="
	${CDEPEND}
	dev-libs/check
"
RDEPEND="
	${CDEPEND}
	!net-misc/iputils[arping(+)]
"

FILECAPS=( cap_net_raw /usr/sbin/arping )

src_prepare() {
	default
	eautoreconf
}
