# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils fcaps git-r3

DESCRIPTION="ARP Ping"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=arping"
EGIT_REPO_URI="https://github.com/ThomasHabets/arping"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS=""

DEPEND="
	net-libs/libpcap
	net-libs/libnet:1.1
"
RDEPEND="
	${DEPEND}
	!net-misc/iputils[arping(+)]
"

FILECAPS=( cap_net_raw /usr/sbin/arping )

src_prepare() {
	eautoreconf
}
